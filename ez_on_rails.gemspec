require_relative "lib/ez_on_rails/version"

Gem::Specification.new do |spec|
  spec.name        = 'ez_on_rails'
  spec.version     = EzOnRails::VERSION
  spec.authors     = ['Andreas Dausenau']
  spec.email       = [ "hello@dausenau.pro" ]
  spec.homepage    = "https://dausenau.pro"
  spec.summary     = 'Application generator for manageable API backends.'
  spec.description = 'Application generator for manageable API backends.'
  spec.license     = 'MIT'
  spec.required_ruby_version = '>=3.3.5'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency 'cancancan', '~> 3.4.0'
  spec.add_dependency 'cocoon', '~> 1.2.15'
  spec.add_dependency 'devise', '~> 4.9.0'
  spec.add_dependency 'devise_token_auth', '~> 1.2.1'
  spec.add_dependency 'doorkeeper', '~> 5.6.5'
  spec.add_dependency 'factory_bot_rails', '~> 6.4.4'
  spec.add_dependency 'faker', '~> 3.1.1'
  spec.add_dependency 'image_processing', '~> 1.12.2'
  spec.add_dependency 'importmap-rails', '~> 1.1.5'
  spec.add_dependency 'jb', '~> 0.8.0'
  spec.add_dependency 'json_schemer', '~> 0.2.24'
  spec.add_dependency 'loaf', '~> 0.10.0'
  spec.add_dependency 'mini_magick', '~> 4.12.0'
  spec.add_dependency 'nilify_blanks', '~> 1.4.0'
  spec.add_dependency 'omniauth-gitlab', '~> 4.1.0'
  spec.add_dependency 'omniauth-oauth2', '~> 1.8.0'
  spec.add_dependency 'rails', '~> 7.2.1'
  spec.add_dependency 'ransack', '~> 4.2.1'
  spec.add_dependency 'rspec-rails', '~> 7.0.1'
  spec.add_dependency 'rswag', '~> 2.15.0'
  spec.add_dependency 'rubocop', '~> 1.64.1'
  spec.add_dependency 'rubocop-rails', '~> 2.25.0'
  spec.add_dependency 'rubocop-rspec', '~> 2.29.2'
  spec.add_dependency 'scoped_search', '~> 4.1.10'
  spec.add_dependency 'simple_form', '~> 5.2.0'
  spec.add_dependency 'slim', '~> 5.0.0'
  spec.add_dependency 'sprockets-rails', '~> 3.4.2'
  spec.add_dependency 'stimulus-rails', '~> 1.2.1'
  spec.add_dependency 'turbo-rails', '~> 1.4.0'
  spec.add_dependency 'will_paginate', '~> 3.3.1'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
            'public gem pushes.'
  end
end
