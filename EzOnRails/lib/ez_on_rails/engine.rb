# frozen_string_literal: true

require 'cancancan'
require 'loaf'
require 'devise'
require 'slim'
require 'flag-icons-rails'
require 'jb'
require 'json_schemer'
require 'ransack'
require 'will_paginate'
require 'scoped_search'
require 'simple_form'
require 'cocoon'
require 'mini_magick'
require 'data-confirm-modal'
require 'react-rails'
require 'coffee-rails'
require 'omniauth-gitlab'
require 'omniauth-oauth2'
require 'devise_token_auth'
require 'doorkeeper'
require 'omniauth/strategies/email'
require 'rswag'
require 'factory_bot_rails'
require 'faker'
require 'nilify_blanks'

# Base Engine module.
module EzOnRails
  # Base Engine class.
  class Engine < ::Rails::Engine
    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot
      g.factory_bot dir: 'spec/factories'
    end

    # add locale paths to be loaded for the host application
    config.before_initialize do
      config.i18n.load_path += Dir["#{config.root}/config/locales/**/*.yml"]
    end

    # add factory paths to be loaded for the host application
    config.factory_bot.definition_file_paths += [File.expand_path('../../spec/factories', __dir__)]

    # precompile assets that have not to be included by the application
    initializer 'ez_on_rails.assets.precompile' do |app|
      app.config.assets.precompile += %w[ez_on_rails.css]
    end

    # BEGIN: Webpacker integratiom from https://github.com/rails/webpacker/blob/master/docs/engines.md
    initializer 'webpacker.proxy' do |app|
      insert_middleware = begin
        EzOnRails.webpacker.config.dev_server.present?
      rescue StandardError
        nil
      end
      next unless insert_middleware

      app.middleware.insert_before(
        0, Webpacker::DevServerProxy, # "Webpacker::DevServerProxy" if Rails version < 5
        ssl_verify_none: true,
        webpacker: EzOnRails.webpacker
      )
    end

    config.app_middleware.use(
      Rack::Static,
      urls: ['/packs'], root: "#{config.root}/public"
    )
    # END: Webpacker integration
  end
end
