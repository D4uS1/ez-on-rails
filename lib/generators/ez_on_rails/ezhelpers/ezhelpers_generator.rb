# frozen_string_literal: true

require 'rails/generators'

module EzOnRails
  # Generator for creating all helpers that are used to render things in
  # the application.
  class Ezhelpers < Rails::Generators::Base

    source_root File.expand_path('../../../../app', __dir__)

    # Generates the helper to render things.
    def generate_render_info_helpers
      directory 'helpers/ez_on_rails/ez_scaff', 'app/helpers/ez_on_rails/ez_scaff'
    end

    # Copies the paginator renderer.
    def generate_paginator_renderer
      copy_file 'helpers/ez_on_rails/ez_paginator_renderer.rb', 'app/helpers/ez_on_rails/ez_paginator_renderer.rb'
    end
  end
end
