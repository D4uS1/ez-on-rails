# frozen_string_literal: true

require 'cancancan'
require 'loaf'
require 'devise'
require 'slim'
require 'importmap-rails'
require 'jb'
require 'json_schemer'
require 'ransack'
require 'will_paginate'
require 'scoped_search'
require 'simple_form'
require 'cocoon'
require 'mini_magick'
require 'omniauth-gitlab'
require 'omniauth-oauth2'
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
      # NOTE: this will add pins from this engine to the main app
      # https://github.com/rails/importmap-rails#composing-import-maps
      app.config.importmap.paths.unshift(root.join('config/importmap.rb'))

      # NOTE: something about cache; I did not look into it.
      # https://github.com/rails/importmap-rails#sweeping-the-cache-in-development-and-test
      app.config.importmap.cache_sweepers << root.join('app/javascript/ez_on_rails')
    end

    # NOTE: add engine manifest to precompile assets in production
    initializer 'ez_on_rails.assets' do |app|
      app.config.assets.precompile += %w[ez_on_rails.css ez_on_rails.js]
    end
    # END Importmap integration
  end
end
