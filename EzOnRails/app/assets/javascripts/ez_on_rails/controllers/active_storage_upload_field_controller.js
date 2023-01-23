import { Controller } from "@hotwired/stimulus"
import * as ActiveStorage from '@rails/activestorage'

/**
 * File uploader for the rails active storage.
 * Needed to register events. An instance of the uploader is passed to the direct upload of the active
 * storage package.
 */
class ActiveStorageUploader {
    /**
     * Constructor takes the callback used to indicate the progress.
     * The progressCallback is expected to be a function accepting the current active storage upload progress as parameter.
     *
     * @param progressCallback
     */
    constructor(progressCallback) {
        this.progressCallback = progressCallback;
    }

    /**
     * Called by the active storage.
     * Event listeners for the direct upload can be appended here.
     * Will append an progress event listener with the callback that was passed in the constructor.
     *
     * @param request
     */
    directUploadWillStoreFileWithXHR = (request) => {
        request.upload.addEventListener("progress", (event) => this.progressCallback(event));
    };
}


/**
 * Stimulus controller for the active storage upload field.
 */
export default class extends Controller {
    static targets = ["filesContainer", "fileInput", "errorContainer"]

    /**
     * Constructor assigns values given by the to class instance variables.
     * Updates the container view to show initially existing files.
     */
    connect() {
        this.maxSizeError = this.data.get("maxSizeError")
        this.maxFilesError = this.data.get("maxFilesError")
        this.invalidFormatError = this.data.get("invalidFormatError")
        this.multiple = this.data.get("multiple") === "true"
        this.maxFiles = this.data.get("maxFiles")
        this.maxSize = this.data.get("maxSize")
        this.accept = this.data.get("accept")
        this.inputName = this.data.get("inputName")
        this.inputId = this.data.get("inputId")
        this.existingFiles = JSON.parse(this.data.get("existingFiles"))
        this.currentUploadsCount = 0;

        this.updateFilesContainer();
    }

    /**
     * Called if the selected files changes.
     * Checks sizes, formats and number of selected files and starts uploading all files.
     *
     * @param event
     */
    onFileSelect(event) {
        // hide previous errors
        this.showError(null)

        // get selected files
        const selectedFiles = this.fileInputTarget.files;

        // check files count
        const filesCount = this.existingFiles.length + this.currentUploadsCount + selectedFiles.length;
        const maxFilesCount = !this.multiple ? 1 : (this.maxFiles || null);
        if (maxFilesCount && filesCount > maxFilesCount) {
            return this.showError(this.maxFilesError)
        }

        // check file types
        if (this.accept) {
            for (const file of selectedFiles) {
                if (!this.fileTypeMatches(file.type, this.accept)) {
                    return this.showError(this.invalidFormatError);
                }
            }
        }

        // check file size
        if (this.maxSize) {
            for (const file of selectedFiles) {
                if (file.size > this.maxSize) {
                    return this.showError(this.maxSizeError);
                }
            }
        }

        // Start uploading each file and add it to the current files
        for (const selectedFile of selectedFiles) {
            this.startFileUpload(selectedFile);
        }

        // Update the container to show all current files
        this.updateFilesContainer();
    }

    onClickDelete(event) {
        const signedId = event.params.signedId;
        if (!signedId) return;

        // Delete from server side
        this.deleteFileFromServer(signedId);

        // Delete from ui
        this.existingFiles = this.existingFiles.filter((existingFile) => existingFile.signed_id !== signedId);
        this.updateFilesContainer();
    }

    /**
     * Starts uploading the specified file.
     * File is expected to be a file selected via a file input field.
     * The upload progress is tracked via the onDirectUploadProgress method.
     * The file is also added to the instance variable to track the currentFiles.
     *
     * @param file
     */
    startFileUpload(file) {
        // upload the file to the active storage
        let uploader = new ActiveStorageUploader(this.onDirectUploadProgress)
        let upload = new ActiveStorage.DirectUpload(file, '/ez_on_rails/active_storage/blobs/create_direct_upload', uploader);

        // this is used to show the uploading files in the view
        this.currentUploadsCount++;

        upload.create((error, blob) => {
            this.currentUploadsCount--;

            // if some error occurs, just print it to the console and do nothing else
            if (error) {
                console.log("Image Error:", error);
            } else {
                let fileInfo = { signed_id: blob.signed_id, preview_image: null, preview_text: null }

                // create preview image, if this is an image, otherwise, just create a preview Text
                if (file.type.includes("image")) {
                    fileInfo.preview_image = URL.createObjectURL(file);
                } else {
                    fileInfo.preview_text = file.name;
                }

                // Set current files to render them
                this.existingFiles.push(fileInfo);
            }

            // Update UI
            this.updateFilesContainer();
        });
    }

    /**
     * Removes the file having the given signedId from the server.
     *
     * @param signedId
     */
    deleteFileFromServer(signedId) {
        fetch(`/ez_on_rails/active_storage/blobs/${signedId}`, {
            method: "DELETE",
            headers: {
                "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
            },
        }).then();
    };

    /**
     * Called to track the upload progress of a file.
     *
     * @param progressEvent
     */
    onDirectUploadProgress(progressEvent) { }

    /**
     * Shows the specified errorText in the errorContainer.
     * If errorText is null or undefined, the errorContainer will be hidden.
     *
     * @param errorText
     */
    showError(errorText) {
        if (errorText){
            this.errorContainerTarget.classList.remove("hidden")
            this.errorContainerTarget.innerHTML = errorText
        } else {
            this.errorContainerTarget.classList.add("hidden")
            this.errorContainerTarget.innerHTML = ''
        }
    }

    /**
     * Returns whether the specified fileType matches any of the specified expected file types.
     * expectedFileTypes is expected to be a comma separated value of valid file types.
     * Stars (*) are allowed to define any valid "subtype", like image/*.
     *
     * @param fileType
     * @param expectedFileTypes
     */
    fileTypeMatches(fileType, expectedFileTypes) {
        // remove all whitespaces
        expectedFileTypes = expectedFileTypes.replace(/\s/g, "");

        // convert to array
        expectedFileTypes = expectedFileTypes.split(',');

        // check the types
        return expectedFileTypes.some((expectedFileType) => {
            if (expectedFileType.endsWith('/*')) {
                const mainType = expectedFileType.split('/')[0];
                return fileType.startsWith(mainType);
            } else {
                return expectedFileType === fileType;
            }
        })
    }

    /**
     * Returns a view for a file described by the specified fileInfo.
     * The fileInfo is an json object expected to have the following properties:
     *  signed_id: string - the signedId used by rails to identify the file in the active storage
     *  preview_image - a relative path to an preview image fo the file, if given the image will be shown, otherwise preview_text will be shown
     *  preview_text - a text that is shown to the user, if preview_image is not given.
     *
     * @param fileInfo
     */
    fileViewTemplate(fileInfo) {
        const bodyHtml = fileInfo.preview_image ?
            `
                <img
                    src="${fileInfo.preview_image}"
                    class="rounded m-auto d-block p-1 mw-100 m-0"
                />
            `
                :
            `
                <span class="p-4">
                    ${fileInfo.preview_text}
                </span>
            `;

        return `
            <div class="card mb-4 w-25 active-storage-upload-field-file-container">
                <div class="card-header p-1">
                    <button type="button" 
                            class="active-storage-upload-field-delete-button"
                            data-action="active-storage-upload-field#onClickDelete"
                            data-active-storage-upload-field-signed-id-param="${fileInfo.signed_id}">
                        <span>&times;</span>
                    </button>
                </div>
                <div class="d-flex justify-content-center align-items-center w-100 h-100">
                    ${bodyHtml}
                </div>
                <input type="hidden" id="${this.inputId}" name="${this.inputName}"
                      value="${fileInfo.signed_id}" readOnly={true}/>
            </div>
        `
    }

    /**
     * Returns a view for a currently uploading file.
     */
    fileUploadTemplate() {
        return `
            <div class="card mb-4 w-25">
                <div class="spinner-border" role="status">
                    <span class="visually-hidden">Loading...</span>
                </div>
            </div>
        `
    }

    /**
     * Updates the currently shown files in the filesContainer.
     * The current uploads are also added as placeholders.
     */
    updateFilesContainer() {
        let html = `
            <div class="container-fluid">
                <div class="row gap-3">
                    ${this.existingFiles.map((fileInfo) => this.fileViewTemplate(fileInfo)).join(' ')}
                    ${new Array(this.currentUploadsCount).map(() => this.fileUploadTemplate()).join(' ')}
                </div>
            </div>
        `

        this.filesContainerTarget.innerHTML = html;
    }


}
