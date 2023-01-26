# frozen_string_literal: true

# Helper used by specs.
module EzTestHelper
  # Returns the json content from the specified view file in the file_path.
  # The file_path must be relative to the views directory.
  def json_from_view(view_file_path, locals = {})
    # use resource controller here to get helpers like the current_ability in test views
    JSON.parse(EzOnRails::Api::ResourceController.render(view_file_path, locals: locals))
  end

  # Visits the login page and executes the login form by using the specified credentials.
  def system_log_in(email, password)
    visit 'users/sign_in'
    fill_in 'user_email', with: email
    fill_in 'user_password', with: password
    click_on 'button' # Login button has name button
  end

  # Takes a screenshot from the current page of the system test and saves it into the
  # tmp/screenshots directory using the specified filename.
  # If the filename is expected to have no file ending. The type will be set as png automaticly.
  def system_save_screenshot(filename)
    page.save_screenshot Rails.root.join('tmp', 'screenshots', "#{filename}.png")
  end

  # Accepts a block that is executed within that all confirm dialogs are accepted or declined, depending
  # on the specified accept parameter.
  # This is a hack, because using the default capybara accept functions resulted in not finding the dialog.
  #
  # Source: https://github.com/thoughtbot/capybara-webkit/issues/84
  def handle_confirm(accept = true)
    page.evaluate_script 'window.original_confirm_function = window.confirm'
    page.evaluate_script "window.confirm = function(msg) { return #{!accept.nil?}; }"
    yield
    page.evaluate_script 'window.confirm = window.original_confirm_function'
  end

  # waits for a flash message
  def system_wait_for_flash_message
    find('.alert')
  end

  # helper method wich waits for any ajax request to finish.
  def system_wait_for_ajax
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until system_finished_all_ajax_requests?
    end
  end

  # returns wether all ajax requests has finished.
  # To indicate wether an ajax request is running, the javascript is expected to set
  # the variable ajaxRunning on the window. This should be a boolean that indicates
  # wether some ajax request is running.
  def system_finished_all_ajax_requests?
    res = page.evaluate_script('window.ajaxRunning')

    !res.nil? && res.false
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

    uploaded_file = Rack::Test::UploadedFile.new(tempfile, content_type, binary, original_filename: original_filename)

    ObjectSpace.define_finalizer(uploaded_file, uploaded_file.class.finalize(tempfile))

    uploaded_file
  end
end
