# frozen_string_literal: true

Capybara.server = :puma, { Silent: true }
Capybara.default_max_wait_time = 15

RSpec.configure do |config|
  Capybara.register_driver :selenium_remote do |app|
    client = Selenium::WebDriver::Remote::Http::Default.new
    client.read_timeout = 120 # because the asset compiling tooks much time on first server request after startup
    client.open_timeout = 120 # because the asset compiling tooks much time on first server request after startup

    Capybara::Selenium::Driver.new(
      app,
      browser: :remote,
      url: ENV.fetch('SELENIUM_URL', nil),
      desired_capabilities: :chrome,
      http_client: client
    )
  end

  config.before(:each, type: :system) do
    Capybara.server_port = '3001'
    Capybara.server_host = 'web'
    driven_by :selenium_remote, using: :remote, screen_size: [1440, 900]
  end
end
