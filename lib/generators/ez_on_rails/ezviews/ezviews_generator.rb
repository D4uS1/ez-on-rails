# frozen_string_literal: true

require 'rails/generators'

module EzOnRails
  # Generator for creating all resources needed to customize the views and the layout
  # of the application.
  class Ezviews < Rails::Generators::Base

    source_root File.expand_path('../../../../app', __dir__)

    # Copies the layout to the main application.
    def generate_layout
      directory 'views/ez_on_rails/layouts', 'app/views/ez_on_rails/layouts'
    end

    # Copies all Partials to the main application.
    def generate_partials
      directory 'views/ez_on_rails/shared', 'app/views/ez_on_rails/shared'
    end
  end
end
