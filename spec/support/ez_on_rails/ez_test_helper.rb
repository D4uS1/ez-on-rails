# frozen_string_literal: true

# Helper used by specs.
module EzTestHelper
  # Returns the json content from the specified view file in the file_path.
  # The file_path must be relative to the views directory.
  def json_from_view(view_file_path, locals = {})
    # use resource controller here to get helpers like the current_ability in test views
    JSON.parse(EzOnRails::Api::ResourceController.render(view_file_path, locals:))
  end

  # Removes all uploaded test files from disk.
  def clear_uploaded_test_files
    FileUtils.rm_rf Rails.root.join('tmp/storage')
    Rails.root.join('tmp/storage').mkdir
  end

  # Uploads a file for testing purposes to the active storage.
  # This is a helper to have a more readable way to upload a file for testing.
  def self.upload_file(src, content_type)
    Rack::Test::UploadedFile.new(Rails.root.join(src), content_type)
  end
end
