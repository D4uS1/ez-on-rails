# frozen_string_literal: true

# Contains multiple helper methods for api purposes.
module EzOnRails::EzApiHelper
  # Returns a hash having the necessary information about the specified
  # attachment to be rendered on client side. This information includes
  # the path, signed_id and the filename.
  def attachment_blob_json(attachment)
    return nil if attachment.blank?

    {
      path: rails_blob_path(attachment),
      signed_id: attachment.signed_id,
      filename: attachment.filename
    }
  end
end
