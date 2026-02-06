# frozen_string_literal: true

require 'factory_bot_rails'
require 'support/ez_on_rails/ez_test_helper'
require 'support/ez_on_rails/ez_auth_test_helper'

RSpec.configure do |config|
  OmniAuth.config.test_mode = true

  # Add those helpers to be available for each test
  config.include FactoryBot::Syntax::Methods
  config.include Devise::Test::ControllerHelpers, type: :view
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include EzTestHelper
  config.include EzAuthTestHelper
  config.include AbstractController::Translation
  config.include Rails.application.routes.url_helpers

  # initialy remove all old permissions and load new ones.
  config.before :suite do
    # first remove all data

    EzOnRails::OwnershipInfo.delete_all
    EzOnRails::ResourceReadAccess.delete_all
    EzOnRails::ResourceWriteAccess.delete_all
    EzOnRails::ResourceDestroyAccess.delete_all
    EzOnRails::UserGroupAssignment.delete_all
    EzOnRails::GroupAccess.delete_all
    EzOnRails::Group.delete_all
    User.delete_all

    # load new data

    Rails.application.load_seed
  end

  # remove test files
  config.after :suite do
    FileUtils.rm_rf(Rails.root.join('tmp/storage'))
  end
end
