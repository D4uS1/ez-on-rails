# frozen_string_literal: true

# lib/generators/ezscaff/ezscaff_generator.rb

require 'rails/generators'
require 'rails/generators/rails/scaffold/scaffold_generator'
require 'rails/generators/active_record/migration'
require 'helper/ez_on_rails/resource_helper'
require 'helper/ez_on_rails/route_helper'

module EzOnRails
  # Scaffold generator for model, view and controllers like the default scaffold generator
  # creates. The difference is that the views uses some partials which will be copied to the shared
  # directory. Hence the default behavior of each model which is created by thie ezscaff generator
  # can be changed by changing the partials behavior. The Generator executes the default scaffold
  # generator to place all files including the active record, migration etc. After that it will
  # overwrite the generated controller and views.
  # Please read the README file for further information.
  class EzscaffGenerator < Rails::Generators::ScaffoldGenerator
    include ::ActiveRecord::Generators::Migration
    include ::EzOnRails::ResourceHelper
    include ::EzOnRails::RouteHelper

    source_root File.expand_path('templates', __dir__)

    class_option :sharable, type: :boolean, default: false

    # Extracts the given options from the command lien arguments and saves them to instance variables.
    def set_options
      @sharable = options['sharable']
    end


    # which is used by the views.
    def generate_helper
      template 'helper.rb.erb',
               File.join('app/helpers', class_path, "#{plural_file_name}_helper.rb"), force: true
    end

    # Generates the views for index, show, new and edit.
    def generate_views
      template 'index.html.slim.erb',
               File.join('app/views', controller_file_path, 'index.html.slim'), force: true
      template 'show.html.slim.erb',
               File.join('app/views', controller_file_path, 'show.html.slim'), force: true
      template 'new.html.slim.erb',
               File.join('app/views', controller_file_path, 'new.html.slim'), force: true
      template 'edit.html.slim.erb',
               File.join('app/views', controller_file_path, 'edit.html.slim'), force: true
    end

    # Generates json builders.
    def generate_builders
      # delete wrong namespaced file if exists
      File.delete File.join('app/views', controller_file_path, "_#{singular_table_name}.json.jbuilder")

      template '_resources.json.jb.erb',
               File.join('app/views', controller_file_path, "_#{plural_file_name}.json.jb"), force: true
      template 'index.json.jb.erb',
               File.join('app/views', controller_file_path, 'index.json.jb'), force: true
      template '_resource.json.jb.erb',
               File.join('app/views', controller_file_path, "_#{file_name}.json.jb"), force: true
      template 'show.json.jb.erb',
               File.join('app/views', controller_file_path, 'show.json.jb'), force: true
    end

    # generates the controller.
    def generate_controller
      template 'controller.rb.erb',
               File.join('app/controllers',
                         controller_class_path, "#{controller_file_name}_controller.rb"), force: true
    end

    # Generates the model
    def generate_model
      # Add attribute to model
      template 'model.rb.erb',
               File.join('app/models', class_path, "#{file_name}.rb"), force: true
    end

    # Generates the migration file
    def generate_migration
      # Delete old migration file
      Dir.glob("db/migrate/*_create_#{plural_table_name}.rb").each { |file| File.delete file }

      # create own migration file
      migration_template 'migration.rb.erb',
                         File.join(db_migrate_path, "create_#{plural_file_name}.rb"), force: true
    end

    # Generates the locale files for this scaffold.
    def generate_locale_files
      template 'locale.en.yml.erb', File.join('config/locales', class_path, "#{file_name}.en.yml")
      template 'locale.de.yml.erb', File.join('config/locales', class_path, "#{file_name}.de.yml")
    end

    # Removes the unnecessary files which are not needed by this method of scaffolding.
    def remove_unused_files
      # we use slim, not erb
      File.delete File.join('app/views', controller_file_path, '_form.html.erb')
      File.delete File.join('app/views', controller_file_path, 'edit.html.erb')
      File.delete File.join('app/views', controller_file_path, 'index.html.erb')
      File.delete File.join('app/views', controller_file_path, 'new.html.erb')
      File.delete File.join('app/views', controller_file_path, 'show.html.erb')

      # we use jb, not jbuilder
      File.delete File.join('app/views', controller_file_path, 'index.json.jbuilder')
      File.delete File.join('app/views', controller_file_path, 'show.json.jbuilder')

      # Table name prefix file not needed, because we do not use prefixes
      if class_path.length > 0
        File.delete "#{File.join('app/models', class_path)}.rb"
      end

      # remove assets
      File.delete File.join('app/assets/stylesheets', class_path, "#{plural_file_name}.scss")
      File.delete File.join('app/assets/javascripts', class_path, "#{plural_file_name}.coffee")
    end

    # Adds the route to the resource
    def add_to_routes_rb
      # Get the route lines without the language scope
      route_lines = routes_rb_lines(["resources :#{plural_file_name}"], class_path)[1..-2].map do |line|
        line.gsub(/\_/, '\_')
      end

      # Remove old routes, if exists
      print "removing old route:\n#{route_lines.join}"
      gsub_file 'config/routes.rb', /#{route_lines.join}/, ''

      # Add new route
      add_routes(["resources :#{plural_file_name} do",
                  '  collection do',
                  "    match 'search' => '#{plural_file_name}#search', via: %i[get post], as: :search",
                  "    delete :destroy_selections",
                  '  end',
                  'end'], class_path)
    end

    # Removes the scaffold.scss file which is generated by rails scaffold
    # generator by default (for some unknown reason nobody can explain).
    def remove_scaffold_scss
      scaffold_scss = 'app/assets/stylesheets/scaffolds.scss'
      remove_file scaffold_scss if File.exist? scaffold_scss
    end

    # Adds the restriction records to the seed.
    def add_restrictions_to_seed
      append_to_file 'db/seeds.rb', "
# Restrict access to manage #{class_name.pluralize}
EzOnRails::GroupAccess.find_or_create_by! group: super_admin_group#{ class_path.length > 0 ? ', namespace: \'' + class_path.join('/') + '\'' : '' }, controller: '#{plural_file_name}' do |access|
  access.group = super_admin_group#{ class_path.length > 0 ? '
  access.namespace = \'' + class_path.join('/') + '\'' : '' }
  access.controller = '#{plural_file_name}'
  access.owner = super_admin_user
end

"
    end

    # Generates the spec files.
    def generate_specs
      template 'model_spec.rb.erb', File.join('spec/models', class_path, "#{file_name}_spec.rb")
      template 'request_spec.rb.erb',  File.join('spec/requests', class_path, "#{plural_file_name}_spec.rb")
    end

    # Generates the factory for
    def generate_factory
      template 'factory.rb.erb',
               File.join('spec', 'factories', class_path, "#{file_name}_factory.rb")
    end

    # Removes the minitest directory created by the scaffold generator.
    def remove_minitest_directory
      FileUtils.rm_rf('test')
    end

    # Print output
    def print_output
      print "Scaffold generated. Dont forget to migrate the database.\n"
    end

    private

    # METHOD FROM GITHUB: https://github.com/rails/rails/blob/master/activerecord/lib/rails/generators/active_record/migration/migration_generator.rb
    def attributes_with_index
      attributes.select { |a| !a.reference? && a.has_index? }
    end

    # METHOD FROM GITHUB: https://github.com/rails/rails/blob/master/activerecord/lib/rails/generators/active_record/migration/migration_generator.rb
    def parent_class_name
      options[:parent] || 'ApplicationRecord'
    end
  end
end
