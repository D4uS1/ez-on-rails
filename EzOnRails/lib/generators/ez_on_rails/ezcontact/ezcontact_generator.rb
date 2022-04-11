# frozen_string_literal: true

require 'rails/generators'

module EzOnRails
  # Generator for creating all resources to customize the the conatct form.
  class Ezcontact < Rails::Generators::Base

    source_root File.expand_path('../../../..', __dir__)

    # Generates the controller.
    def generate_controller
      copy_file 'app/controllers/contact_form_controller.rb', 'app/controllers/contact_form_controller.rb'
    end

    # Generates the active model of the contact form.
    def generate_models
      copy_file 'app/models/contact_form.rb', 'app/models/contact_form.rb'
    end

    # Generates the helpers.
    def generate_helpers
      copy_file 'app/helpers/contact_form_helper.rb', 'app/helpers/contact_form_helper.rb'
    end

    # Generates the mailer.
    def generate_mailer
      copy_file 'app/mailers/contact_form_mailer.rb', 'app/mailers/contact_form_mailer.rb'
    end

    # Generates the views.
    def generate_views
      directory 'app/views/contact_form', 'app/views/contact_form'
      directory 'app/views/contact_form_mailer', 'app/views/contact_form_mailer'
    end

    # Copies specs related to the copied resources.
    def generate_specs
      copy_file 'spec/requests/contact_form_spec.rb', 'spec/requests/contact_form_spec.rb'
    end

    # Generates the locales.
    def generate_locales
      copy_file 'config/locales/contact_form.de.yml', 'config/locales/contact_form.de.yml'
      copy_file 'config/locales/contact_form.en.yml', 'config/locales/contact_form.en.yml'
    end
  end
end
