# frozen_string_literal: true

require 'helper/ez_on_rails/route_helper'
require 'helper/ez_on_rails/resource_helper'

module EzOnRails
  # Generator for creating a form without an active record model.
  # Please read the README file for further information.
  class EzformGenerator < Rails::Generators::NamedBase
    include ::EzOnRails::RouteHelper
    include ::EzOnRails::ResourceHelper
    source_root File.expand_path('templates', __dir__)
    argument :attributes, type: :array, default: [], banner: 'attribute:type attribute:type...'

    # Creates the active Model.
    def generate_model
      template 'model.rb.erb',
               File.join('app/models', class_path, "#{file_name}.rb")
    end

    # Creates the Controller of the Active Model.
    def generate_controller
      template 'controller.rb.erb',
               File.join('app/controllers', class_path, "#{file_name}_controller.rb")
    end

    # Creates the Controller of the Active Model.
    def generate_helper
      template 'helper.rb.erb',
               File.join('app/helpers', class_path, "#{file_name}_helper.rb")
    end

    # Creates the View of the Active Model.
    def generate_view
      template 'index.html.slim.erb',
               File.join('app/views', file_path, 'index.html.slim')
      template 'success.html.slim.erb',
               File.join('app/views', file_path, 'success.html.slim')
    end

    # Generates the locale files for this form.
    def generate_locale_files
      template 'locale.en.yml.erb', File.join('config/locales', class_path, "#{file_name}.en.yml")
      template 'locale.de.yml.erb', File.join('config/locales', class_path, "#{file_name}.de.yml")
    end

    # Generates the spec files.
    def generate_specs
      template 'model_spec.rb.erb', File.join('spec/models', class_path, "#{file_name}_spec.rb")
      template 'request_spec.rb.erb',  File.join('spec/requests', class_path, "#{file_name}_spec.rb")
    end

    # Adds the restriction records to the seed.
    def add_restrictions_to_seed
      append_to_file 'db/seeds.rb', "
# Restrict access to access #{class_name} form
EzOnRails::GroupAccess.find_or_create_by! group: super_admin_group#{ class_path.length > 0 ? ', namespace: \'' + class_path.join('/') + '\'' : '' }, controller: '#{file_name}' do |access|
  access.group = super_admin_group#{ class_path.length > 0 ? '
  access.namespace = \'' + class_path.join('/') + '\'' : '' }
  access.controller = '#{file_name}'
  access.owner = super_admin_user
end

"
    end

    # Creates the route to the active model view action.
    # Adds the route to the dashboard
    def add_to_routes_rb
      add_routes(
        [
          "get '#{file_name}/', to: '#{file_name}#index'",
          "post '#{file_name}', to: '#{file_name}#submit'",
          "get '#{file_name}/success', to: '#{file_name}#success'"
        ],
        class_path
      )
    end
  end
end
