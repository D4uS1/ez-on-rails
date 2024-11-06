# frozen_string_literal: true

require 'rails/generators'

module EzOnRails
  # Generator for creating all resources to customize the the welcome page.
  class Ezwelcome < Rails::Generators::Base

    source_root File.expand_path('../../../..', __dir__)

    # Generates the controller
    def generate_controller
      copy_file 'app/controllers/welcome_controller.rb', 'app/controllers/welcome_controller.rb'
    end

    # Generates the view files.
    def generate_view
      directory 'app/views/welcome', 'app/views/welcome'
    end

    # Generates the locatization files.
    def generate_locales
      directory 'config/locales/welcome', 'config/locales/welcome'
    end
  end
end
