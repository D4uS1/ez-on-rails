# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'ez_on_rails/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'ez_on_rails'
  spec.version     = EzOnRails::VERSION
  spec.authors     = ['Andreas Dausenau']
  spec.summary     = 'Application generator for manageable API backends.'
  spec.description = 'Application generator for manageable API backends.'
  spec.license     = 'MIT'
  spec.required_ruby_version = '>=3.0.2'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
          'public gem pushes.'
  end

  spec.files = Dir['{app,config,db,lib,spec,public}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'cancancan', '~> 3.4.0'
  spec.add_dependency 'cocoon', '~> 1.2.15'
  spec.add_dependency 'devise', '~> 4.9.0'
  spec.add_dependency 'devise_token_auth', '~> 1.2.1'
  spec.add_dependency 'doorkeeper', '~> 5.6.5'
  spec.add_dependency 'factory_bot_rails', '~> 6.2.0'
  spec.add_dependency 'faker', '~> 3.1.1'
  spec.add_dependency 'image_processing', '~> 1.12.2'
  spec.add_dependency 'importmap-rails', '~> 1.1.5'
  spec.add_dependency 'jb', '~> 0.8.0'
  spec.add_dependency 'json_schemer', '~> 0.2.24'
  spec.add_dependency 'loaf', '~> 0.10.0'
  spec.add_dependency 'mini_magick', '~> 4.12.0'
  spec.add_dependency 'nilify_blanks', '~> 1.4.0'
  spec.add_dependency 'omniauth-gitlab', '~> 2.0.0'
  spec.add_dependency 'omniauth-oauth2', '~> 1.7.3'
  spec.add_dependency 'rails', '~> 7.0.4'
  spec.add_dependency 'ransack', '~> 4.0.0'
  spec.add_dependency 'rspec-rails', '~> 6.0.1'
  spec.add_dependency 'rswag', '~> 2.8.0'
  spec.add_dependency 'rubocop', '~> 1.47.0'
  spec.add_dependency 'rubocop-rails', '~> 2.18.0'
  spec.add_dependency 'rubocop-rspec', '~> 2.18.1'
  spec.add_dependency 'scoped_search', '~> 4.1.10'
  spec.add_dependency 'simple_form', '~> 5.2.0'
  spec.add_dependency 'slim', '~> 5.0.0'
  spec.add_dependency 'sprockets-rails', '~> 3.4.2'
  spec.add_dependency 'stimulus-rails', '~> 1.2.1'
  spec.add_dependency 'turbo-rails', '~> 1.4.0'
  spec.add_dependency 'will_paginate', '~> 3.3.1'
  spec.metadata = {
    'rubygems_mfa_required' => 'true'
  }
end
