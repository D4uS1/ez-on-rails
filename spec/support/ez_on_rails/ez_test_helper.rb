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

  # Temporary fix for: https://github.com/rails/rails/issues/41991
  # TODO: Remove if not necessary anymore
  def self.upload_file(src, content_type, binary: false)
    path = Rails.root.join(src)
    original_filename = ::File.basename(path)

    content = File.read(path)
    tempfile = Tempfile.open(original_filename)
    tempfile.write content
    tempfile.rewind

    uploaded_file = Rack::Test::UploadedFile.new(tempfile, content_type, binary, original_filename:)

    ObjectSpace.define_finalizer(uploaded_file, uploaded_file.class.finalize(tempfile))

    uploaded_file
  end
end
