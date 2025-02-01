# frozen_string_literal: true

require 'rails/generators'

module EzOnRails
  # Generator for creating all resources to customize the the imprint.
  class Ezimprint < Rails::Generators::Base
    source_root File.expand_path('../../../..', __dir__)

    # Generates the controller.
    def generate_controller
      copy_file 'app/controllers/imprint_controller.rb', 'app/controllers/imprint_controller.rb'
    end

    # Generates the view files.
    def generate_view
      directory 'app/views/imprint', 'app/views/imprint'
    end

    # Generates the locatization files.
    def generate_locales
      copy_file 'config/locales/imprint.de.yml', 'config/locales/imprint.de.yml'
      copy_file 'config/locales/imprint.en.yml', 'config/locales/imprint.en.yml'
    end
  end
end
