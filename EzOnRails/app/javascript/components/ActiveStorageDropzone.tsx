import React, {useEffect, useState} from "react";
import Dropzone, { DropEvent, FileRejection } from 'react-dropzone';
import * as ActiveStorage from 'activestorage'
import axios from 'axios';

/**
 * Describes a rails file blob.
 */
interface RailsFileBlob {
    signed_id: string;
    preview_image?: string;
    preview_text?: string;
}

/**
 * Props for the ActiveStorageDropzone component.
 */
interface ActiveStorageDropzoneProps {
    // The name of the input field
    input_name: string;

    // The id of the input field
    input_id: string;

    // Used for edit action to initialiy load the existing files to the dropzone
    existing_files?: RailsFileBlob[];

    // The text shown in the dropzone component
    text_dropzone?: string;

    // The text shown in the pastezone component
    text_pastezone?: string;

    // Indicates whether multiple files are alowed.
    multiple?: false;

    // If multiple is true, this is the maximum number of allowed files
    max_files?: number;

    // The maximum size of a file allowed
    max_size?: number;

    // One media type to filter allowed files. This can be used to allow only images for instance
    accept?: string;

    // The error text shown if the user wants to drop some files that are bigger than allowed
    max_size_error?: string;

    // the error text shown if the user wants to drop more files than allowed
    max_files_error?: string;

    // error text if the format the user pasted in was not valid
    invalid_format_error?: string;
}

/**
 * Describes a file that can be uploaded.
 */
interface DroppedFile {
    // Used by rails to identify the file
    signedId: string;

    // Shown in the dropzone as preview
    previewImage?: string;

    // Shown in the dropzone as preview if no image is existent
    previewText?: string;
}

/**
 * File uploader for the rails active storage.
 * Needed to register events. An instance of the uploader is passed to the direct upload of the active
 * storage package.
 */
class ActiveStorageUploader {
    private progressCallback: (event: ProgressEvent<XMLHttpRequestEventTarget>) => void;

    /**
     * Constructor takes the callback used to indicate the progress.
     *
     * @param progressCallback
     */
    constructor(progressCallback: (event: any) => void) {
        this.progressCallback = progressCallback;
    }

    /**
     * Called by the active storage.
     * Event listeners for the direct upload can be appended here.
     * Will append an progress event listener.
     *
     * @param request
     */
    directUploadWillStoreFileWithXHR = (request: XMLHttpRequest) => {
        request.upload.addEventListener("progress", (event:  ProgressEvent<XMLHttpRequestEventTarget>) => this.progressCallback(event));
    };
}


/**
 * Image Uploader component for active storage content having a react dropzone
 * and some input field for pasting content.
 */
export const ActiveStorageDropzone = (props: ActiveStorageDropzoneProps) => {

    const [files, setFiles] = useState<DroppedFile[]>([])
    const [uploadsInProgress, setUploadsInProgress] = useState<number>(0)
    const [errorText, setErrorText] = useState<string | null>(null);

    /**
     * Called if the existing_files prop changes. Converts the existing_files Rails blobs
     * to files and loads them into the state.
     */
    useEffect(() => {
        let currentFiles: DroppedFile[] = [];
        if (!props.existing_files) {
            return;
        }

        props.existing_files.forEach((existingFile) => {
            let file: DroppedFile = {signedId: existingFile.signed_id};
            if (existingFile.preview_image) {
                file.previewImage = existingFile.preview_image;
            }
            if (existingFile.preview_text) {
                file.previewText = existingFile.preview_text;
            }

            currentFiles.push(file);
        });

        setFiles(currentFiles);
    }, [props.existing_files])

    /**
     * Removes the file having the given signedId from the server.
     *
     * @param signedId
     */
    const removeFileFromServer = (signedId: string) => {
        axios.delete('/ez_on_rails/active_storage/blobs/' + signedId).then();
    };

    /**
     * Removes the file having the specified signedId from the server and the dropzone,
     *
     * @param event The javascript event to stop other onclick callbacks.
     * @param signedId The signed id of the image.
     */
    const removeFile = (event: React.MouseEvent, signedId: string) => {
        // Remove file from rails blobs to prevent garbage
        removeFileFromServer(signedId);

        // Remove from this component
        const currentFiles = files.filter((file) => signedId !== file.signedId);
        setFiles([...currentFiles]);

        // Supress dropzones onclick callback
        event.stopPropagation();
    };

    /**
     * Called if some direct upload updates its progress.
     * Updates the state to rerender the view.
     *
     * @param event
     */
    const onDirectUploadProgress = (event: ProgressEvent<XMLHttpRequestEventTarget>) => {
        if (event.loaded / event.total >= 0.9999999) {
            console.log("File upload completed.");
        }
    };

    /**
     * Called by the dropzone if some file is dropped into it.
     * Uploads the file to the active storage.
     *
     * @param files The dropped files.
     */
    const onDropAccepted = (acceptedFiles: File[]) => {
        setErrorText(null);

        // if we have no acceptedFiles, just leave
        if (!acceptedFiles.length) {
            return;
        }

        // Only allow as much as possible acceptedFiles allowed
        if (props.max_files) {
            const maxNewFiles = props.max_files - (files.length + uploadsInProgress);

            if (maxNewFiles < acceptedFiles.length) {
                showError(props.max_files_error || "No more files allowed.")
            }

            acceptedFiles = acceptedFiles.slice(0, maxNewFiles);
        }

        // Only allow files with limited size
        if (props.max_size) {
            const sizeFilteredFiles = acceptedFiles.filter((file) => file.size <= props.max_size);
            if (sizeFilteredFiles.length < acceptedFiles.length) {
                showError(props.max_size_error || "Some files were to large.")
            }
            acceptedFiles = sizeFilteredFiles;
        }


        // Update the number of uploads for feedback
        setUploadsInProgress((uploadsInProgress) => uploadsInProgress + acceptedFiles.length);

        // try to upload every file
        acceptedFiles.forEach((acceptedFile) => {
            // upload the file to the active storage
            let uploader = new ActiveStorageUploader(onDirectUploadProgress)
            let upload = new ActiveStorage.DirectUpload(acceptedFile, '/ez_on_rails/active_storage/blobs/create_direct_upload', uploader);
            upload.create((error, blob) => {
                setUploadsInProgress((uploadsInProgress) => uploadsInProgress - 1)

                // if some error occurs, just print it to the console and do nothing else
                if (error) {
                    console.log("Image Error:", error);
                } else {
                    let file: DroppedFile = {signedId: blob.signed_id}

                    // create preview image, if this is an image, otherwise, just create a preview Text
                    if (acceptedFile.type.includes("image")) {
                        file.previewImage = URL.createObjectURL(acceptedFile);
                    } else {
                        file.previewText = acceptedFile.name;
                    }

                    // Set current files to render them
                    files.push(file);
                    setFiles([...files]);
                }
            });
        });
    };

    /**
     * Called if some value is pasted into the input paste field.
     * Tries to catch the value. If it is a file, it will be pasted into
     * the dropzone.
     *
     * @param event The javascript event.
     */
    const onPaste = (event: React.ClipboardEvent) => {
        // if no clipboard was detected
        if (!event.clipboardData) {
            return;
        }

        // catch all clipboard items, if exists
        let items = event.clipboardData.items;
        if (items === undefined) {
            return;
        }

        let pastedFiles = [];
        for (let i = 0; i < items.length; i++) {
            // this item format is wrong
            if (props.accept && !items[i].type.match(props.accept)) {
                setErrorText(props.invalid_format_error || "Invalid format")
                continue;
            }

            const file = items[i].getAsFile();
            if (file) {
                pastedFiles.push(file);
            }
        }

        onDropAccepted(pastedFiles);
    };


    // preview of the current stated files
    const previews = files.map(file => (
        <div key={file.signedId} className="card mb-4 w-25" style={{flex: "0 0 auto"}}>
            <div className={"card-header p-1"}>
                <button onClick={(event) => removeFile(event, file.signedId)} type="button" className="close"
                        aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div className={"d-flex justify-content-center align-items-center w-100 h-100"}>
                {file.previewImage &&
                <img
                    src={file.previewImage}
                    className={"rounded m-auto d-block p-1 mw-100 m-0"}
                />}
                {file.previewText &&
                <span className="p-4">
                        {file.previewText}
                    </span>}
            </div>
        </div>
    ));

    // shows some indicator for some incoming files
    let progressSpinners: React.ReactNodeArray = [];

    for (let i = 0; i < uploadsInProgress; i++) {
        progressSpinners.push(
            <div key={i} className="card mb-4 w-25" style={{flex: "0 0 auto"}}>
                <div className={"d-flex justify-content-center align-items-center w-100 h-100"}>
                    <div className="text-center p-4">
                        <div className="spinner-border" role="status">
                            <span className="sr-only">Loading...</span>
                        </div>
                    </div>
                </div>
            </div>
        )
    }

    // hidden inputs containing the signed ids for referencing the active storage blobs at form submit
    const signedIdInputs = files.map(file => {
        return <input key={file.signedId} type="hidden" id={props.input_id} name={props.input_name}
                      defaultValue={file.signedId} readOnly={true}/>
    });

    /**
     * Shows the specified error message to the user.
     *
     * @param error
     */
    const showError = (error: string) => {
        setErrorText(error)
    };

    /**
     * Called if some drop in the dropzone was rejected.
     * Indicates whether the reject was in case of size or count of items and displayes a correlating error message.
     *
     * @param fileRejections
     * @param event
     */
    const onDropRejected = (fileRejections: FileRejection[], event: DropEvent) => {
        const errorCodes: string[] = fileRejections.map((fileRejection) => fileRejection.errors[0].code)

        if (errorCodes.indexOf('file-invalid-type') > -1) {
            showError(props.invalid_format_error || 'Invalid format')
        } else if (errorCodes.indexOf('file-too-large') > -1) {
            showError(props.max_size_error || "Some of those files you dropped are too large.")
        } else {
            showError(props.max_files_error || "You can not drop more files.")
        }
    }

    // dropzone having a drop area
    return (
        <div>
            <input type="text"
                   className="w-100 p-2 active-storage-dropzone-pastezone-container"
                   value={props.text_pastezone || "Copy and paste some files here"}
                   onPaste={(event) => onPaste(event)}
                   readOnly/>
            <Dropzone
                onDropAccepted={onDropAccepted}
                onDropRejected={onDropRejected}
                multiple={props.multiple}
                maxSize={props.max_size}
                maxFiles={props.max_files}
                accept={props.accept}
            >
                {({getRootProps, getInputProps}) => (
                    <section>
                        <div {...getRootProps()} className="p-4 active-storage-dropzone-dropzone-container">
                            {/* the file input field, but invisible */}
                            <input {...getInputProps()} />

                            {/* hidden inputs needed by rails, holding the blob signed ids */}
                            {signedIdInputs}

                            <p className={"m-0"}>{props.text_dropzone || "Drag 'n' drop some files here, or click to select files"}</p>

                            {/* The preview of the current uploaded files */}
                            {previews.length > 0 &&
                            <aside className={"card-deck justify-content-center w-100 m-4"}>
                                {previews}
                            </aside>
                            }
                            {progressSpinners.length > 0 &&
                            <aside className={"card-deck justify-content-center w-100 m-4"}>
                                {progressSpinners}
                            </aside>
                            }

                        </div>
                    </section>
                )}
            </Dropzone>
            {errorText ? <div className="pt-1 active-storage-dropzone-error">
                {errorText}
            </div> : null}
        </div>
    );
}

export default ActiveStorageDropzone;
