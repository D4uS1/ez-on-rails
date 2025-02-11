# frozen_string_literal: true

require 'cancancan'
require 'loaf'
require 'devise'
require 'slim'
require 'importmap-rails'
require 'jb'
require 'json_schemer'
require 'rack/cors'
require 'ransack'
require 'will_paginate'
require 'scoped_search'
require 'simple_form'
require 'cocoon'
require 'devise_token_auth'
require 'doorkeeper'
require 'omniauth/strategies/email'
require 'rswag'
require 'factory_bot_rails'
require 'faker'
require 'nilify_blanks'
require 'stimulus-rails'

# Base Engine module.
module EzOnRails
  # Base Engine class.
  class Engine < ::Rails::Engine
    # We do not to have the namespace isolated, because some features should be available
    # without namespace (like eg. the sessions management, users controller or the active storage blobs controller)
    # isolate_namespace EzOnRails

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

    # BEGIN: Importmap integration, source: https://stackoverflow.com/questions/69635552/how-to-set-up-importmap-rails-in-rails-7-engine
    initializer 'ez_on_rails.importmap', before: 'importmap' do |app|
      # this will add pins from this engine to the main app
      app.config.importmap.paths.unshift(root.join('config/importmap.rb'))

      # this forces the specified directories to be watched for changes in development and
      # test environent to "disable" caching for development.
      app.config.importmap.cache_sweepers << root.join('app/assets/javascripts')
    end

    # add engine manifest to precompile assets in production
    initializer 'ez_on_rails.assets' do |app|
      app.config.assets.precompile += %w[ez_on_rails.css ez_on_rails.js]
    end
    # END Importmap integration

    # Run after initializers to include all helpers that are generated using ez-on-rails,
    # to make them available in the engine.
    # This makes uit possible to access helpers from the host application in the engine.
    config.to_prepare do
      EzOnRails::ApplicationController.helper Rails.application.helpers
    end
  end
end
