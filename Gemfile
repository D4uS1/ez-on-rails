# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in ez_on_rails.gemspec.
gemspec

gem 'puma'

gem 'sqlite3'

gem 'sprockets-rails'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'

# Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
gem 'rubocop-rails-omakase', require: false

# Start debugger with binding.b [https://github.com/ruby/debug]
# gem "debug", ">= 1.0.0"

group :test do
  gem 'nyan-cat-formatter'

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem 'brakeman', require: false
end
