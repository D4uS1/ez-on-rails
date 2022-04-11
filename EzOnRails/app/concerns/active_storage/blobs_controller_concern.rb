# frozen_string_literal: true

# Adds methods to implement additional functionality for active storage.
# Needed because there are multiple controllers for additional active storage functionality.
# They are needed because if some direct upload from this app is done, the authentication process
# is another one.
module ActiveStorage::BlobsControllerConcern
  extend ActiveSupport::Concern

  # DELETE action to remove a blob given by its :signed_id.
  def destroy
    blob = ActiveStorage::Blob.find_signed(params[:signed_id])
    return unless blob

    # If there exists some Attachment, delete it
    attachment = ActiveStorage::Attachment.find_by blob_id: blob.id
    attachment&.delete

    # Purge the file and the database entry of the blob
    blob.purge
  end

  # POST api/active_storage/blobs/create_direct_upload
  #
  # Creates a direct upload blob.
  def create_direct_upload
    blob = ActiveStorage::Blob.create_before_direct_upload!(**blob_args)
    render json: direct_upload_json(blob)
  end

  private

  # Permits blob args.
  def blob_args
    params.require(:blob).permit(:filename, :byte_size, :checksum, :content_type, metadata: {}).to_h.symbolize_keys
  end

  # Returns the json for direct upload behaviors
  def direct_upload_json(blob)
    blob.as_json(root: false, methods: :signed_id).merge(direct_upload: {
                                                           url: blob.service_url_for_direct_upload,
                                                           headers: blob.service_headers_for_direct_upload
                                                         })
  end
end
