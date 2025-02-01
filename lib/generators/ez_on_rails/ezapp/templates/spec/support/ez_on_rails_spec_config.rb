# frozen_string_literal: true

require 'factory_bot_rails'
ez_on_rails_dir = Gem::Specification.find_by_name('ez_on_rails').gem_dir
require "#{ez_on_rails_dir}/spec/support/ez_on_rails/ez_test_helper"
require "#{ez_on_rails_dir}/spec/support/ez_on_rails/ez_auth_test_helper"

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

  # initialy load permissions
  config.before :suite do
    Rails.application.load_seed
  end

  # remove test files
  config.after :suite do
    FileUtils.rm_rf(Rails.root.join('tmp/storage'))
  end
end
