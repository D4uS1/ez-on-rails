# frozen_string_literal: true

require 'rails/generators'

module EzOnRails
  # Generator for creating all resources to customize the the privacy policy.
  class Ezprivacy < Rails::Generators::Base

    source_root File.expand_path('../../../..', __dir__)

    # Generates the controller.
    def generate_controller
      copy_file 'app/controllers/privacy_policy_controller.rb', 'app/controllers/privacy_policy_controller.rb'
    end

    # Generates the view files.
    def generate_view
      directory 'app/views/privacy_policy', 'app/views/privacy_policy'
    end

    # Generates the locatization files.
    def generate_locales
      copy_file 'config/locales/privacy_policy.de.yml', 'config/locales/privacy_policy.de.yml'
      copy_file 'config/locales/privacy_policy.en.yml', 'config/locales/privacy_policy.en.yml'
    end
  end
end
