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

  spec.add_dependency 'cancancan'
  spec.add_dependency 'cocoon'
  spec.add_dependency 'devise'
  spec.add_dependency 'devise_token_auth'
  spec.add_dependency 'doorkeeper'
  spec.add_dependency 'factory_bot_rails'
  spec.add_dependency 'faker'
  spec.add_dependency 'image_processing'
  spec.add_dependency 'importmap-rails'
  spec.add_dependency 'jb'
  spec.add_dependency 'json_schemer'
  spec.add_dependency 'loaf'
  spec.add_dependency 'mini_magick'
  spec.add_dependency 'nilify_blanks'
  spec.add_dependency 'omniauth-gitlab'
  spec.add_dependency 'omniauth-oauth2'
  spec.add_dependency 'rails', '~> 7.0.4', '>= 7.0.4'
  spec.add_dependency 'ransack'
  spec.add_dependency 'rspec-rails'
  spec.add_dependency 'rswag'
  spec.add_dependency 'rubocop'
  spec.add_dependency 'rubocop-rails'
  spec.add_dependency 'rubocop-rspec'
  spec.add_dependency 'scoped_search'
  spec.add_dependency 'simple_form'
  spec.add_dependency 'slim'
  spec.add_dependency 'sprockets-rails'
  spec.add_dependency 'stimulus-rails'
  spec.add_dependency 'turbo-rails'
  spec.add_dependency 'will_paginate'
  spec.metadata = {
    'rubygems_mfa_required' => 'true'
  }
end
