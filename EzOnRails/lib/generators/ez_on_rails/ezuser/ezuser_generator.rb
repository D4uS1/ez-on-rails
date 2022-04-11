# frozen_string_literal: true

require 'rails/generators'

module EzOnRails
  # Generator for creating all resources needed to customize the user behavior
  # of an ez_on_rails application.
  # Please read the README file for further information.
  class EzuserGenerator < Rails::Generators::Base

    source_root File.expand_path('../../../..', __dir__)

    # Copies the controllers that should not be inside the EzOnRails namespace.
    def generate_controllers
      directory 'app/controllers/users', 'app/controllers/users'
      copy_file 'app/controllers/api/users_controller.rb', 'app/controllers/api/users_controller.rb'
    end

    # Copies the helpers that should not be inside the EzOnRails namespace.
    def generate_helpers
      copy_file 'app/helpers/users_helper.rb', 'app/helpers/users_helper.rb'
    end

    # Copies the views that should not be inside the EzOnRails namespace.
    def generate_views
      directory 'app/views/users', 'app/views/users'
      directory 'app/views/api/users', 'app/views/users'
    end

    # Copies the models to the app directory.
    def generate_models
      copy_file 'app/models/user.rb', 'app/models/user.rb'
    end

    # Generates the locale files to customize the user messages.
    def generate_locales
      directory 'config/locales/users', 'config/locales/users'
      copy_file 'config/locales/devise.de.yml', 'config/locales/devise.de.yml'
      copy_file 'config/locales/devise.en.yml', 'config/locales/devise.en.yml'
    end

    # Copies specs related to the copied resources.
    def generate_specs
      copy_file 'spec/models/user_spec.rb', 'spec/models/user_spec.rb'
      directory 'spec/requests/users', 'spec/requests/users'
    end

    # Generate Navigation
    def print_finish_message
      print "User resource creation finished.\n"
    end
  end
end
