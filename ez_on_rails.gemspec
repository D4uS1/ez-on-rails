# frozen_string_literal: true

require_relative 'lib/ez_on_rails/version'

Gem::Specification.new do |spec|
  spec.name        = 'ez_on_rails'
  spec.version     = EzOnRails::VERSION
  spec.authors     = ['Andreas Dausenau']
  spec.email       = ['hello@dausenau.pro']
  spec.homepage    = 'https://dausenau.pro'
  spec.summary     = 'Application generator for manageable API backends.'
  spec.description = 'Application generator for manageable API backends.'
  spec.license     = 'MIT'
  spec.required_ruby_version = '>=4.0.1'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/D4uS1/ez-on-rails'
  spec.metadata['changelog_uri'] = 'https://github.com/D4uS1/ez-on-rails/blob/main/Changelogs.md'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir['{app,config,db,lib,spec}/**/*', 'LICENSE', 'Rakefile', 'README.md']
  end

  spec.add_dependency 'cancancan', '~> 3.6.1'
  spec.add_dependency 'cocoon', '~> 1.2.15'
  spec.add_dependency 'devise', '~> 4.9.4'
  spec.add_dependency 'devise_token_auth', '~> 1.2.6'
  spec.add_dependency 'doorkeeper', '~> 5.8.2'
  spec.add_dependency 'factory_bot_rails', '~> 6.5.1'
  spec.add_dependency 'faker', '~> 3.6.0'
  spec.add_dependency 'importmap-rails', '~> 2.2.3'
  spec.add_dependency 'jb', '~> 0.8.2'
  spec.add_dependency 'json_schemer', '~> 2.5.0'
  spec.add_dependency 'loaf', '~> 0.10.0'
  spec.add_dependency 'nilify_blanks', '~> 1.4.0'
  spec.add_dependency 'omniauth-oauth2', '~> 1.9.0'
  spec.add_dependency 'ostruct', '~> 0.6.3' # is not standard lib anymore, otherwise booting the engine will fail
  spec.add_dependency 'propshaft', '~> 1.3.1'
  spec.add_dependency 'rack-cors', '~> 3.0.0'
  spec.add_dependency 'rails', '~> 8.1.2'
  spec.add_dependency 'ransack', '~> 4.4.1'
  spec.add_dependency 'rspec-rails', '~> 8.0.2'
  spec.add_dependency 'rswag', '~> 2.17.0'
  spec.add_dependency 'rubocop', '~> 1.84.1'
  spec.add_dependency 'rubocop-rails', '~> 2.34.3'
  spec.add_dependency 'rubocop-rspec', '~> 3.9.0'
  spec.add_dependency 'scoped_search', '~> 4.3.1'
  spec.add_dependency 'simple_form', '~> 5.4.1'
  spec.add_dependency 'slim', '~> 5.2.1'
  spec.add_dependency 'stimulus-rails', '~> 1.3.4'
  spec.add_dependency 'turbo-rails', '~> 2.0.23'
  spec.add_dependency 'will_paginate', '~> 4.0.1'
end
