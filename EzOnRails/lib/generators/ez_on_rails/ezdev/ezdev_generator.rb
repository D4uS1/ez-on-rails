# frozen_string_literal: true

require 'rails/generators'

module EzOnRails
  # Generator for generating and injecting into files for woking with docker, rubymine and gitlab
  # for some ez_on_rails application.
  class EzdevGenerator < Rails::Generators::NamedBase

    source_root File.expand_path('templates', __dir__)

    # Copies files for development, like .rspec, .gitlab-ci.yml, .rubocop.yml etc.
    def generate_development_files
      copy_file 'rspec', '.rspec' # undotted because of gitignore
      copy_file '.rspec.gitlab-ci', '.rspec.gitlab-ci'
      copy_file '.rubocop.yml', '.rubocop.yml'
      copy_file 'database.gitlab-ci.yml', 'config/database.gitlab-ci.yml'

      template 'database.example.yml.erb', 'config/database.example.yml'
      template 'database.example.yml.erb', 'config/database.yml'
      template '.gitlab-ci.yml.erb', '.gitlab-ci.yml'
    end

    # Injects some dependencies to the gemfile for development purposes.
    def inject_into_gemfile
      append_to_file 'Gemfile', "

# EzOnRails injections begin
group :test do
  gem 'nyan-cat-formatter'
end

# Debugging in RubyMine
group :development, :test do
  # TODO: Replace with default entry if https://github.com/ruby-debug/debase/issues/98 is fixed
  gem 'debase', :git => 'https://github.com/ruby-debug/debase.git', :tag => 'v0.2.5.beta2'
  gem 'ruby-debug-ide'
end

# linting
group :development, :test do
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end
# EzOnRails injections end
      "
    end

    # Injects things to the gitignore
    def inject_into_gitignore
      append_to_file ".gitignore","

# EzOnRails injections begin
# ignore config files to prevent docker collisions
config/database.yml

# Rubymine
.idea/
.generators
.rakeTasks

# Mac
.DS_Store
# EzOnRails injections end

"
    end

    # Generate Navigation
    def print_finish_message
      print "Development setup completed. Dont forgett to unindex config/database.yml if it is in the git index.\n"
    end
  end
end
