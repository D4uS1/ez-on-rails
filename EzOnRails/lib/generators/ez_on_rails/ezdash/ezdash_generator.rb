# frozen_string_literal: true

require 'rails/generators'
require 'helper/ez_on_rails/route_helper'
require 'helper/ez_on_rails/pretty_print_helper'
require 'rails/generators/rails/controller/controller_generator'

# needed because we want to get the current dash_info due to the fact we dont want to replace
# existing tiles
Dir["#{Rails.root}/app/helpers/**/*.rb"].each(&method(:require))

module EzOnRails
  # Generator for creating Dashboards for namespaces.
  # Each controller of the specified namespace will get one place in the dashboard, linking to it.
  # If the controller contains an index action, only the index action will be reffered.
  # Please read the README file for further information.
  class EzdashGenerator < Rails::Generators::NamedBase
    include ::EzOnRails::RouteHelper
    include ::EzOnRails::PrettyPrintHelper

    source_root File.expand_path('templates', __dir__)

    # Builds the new dash_info hash of the dashboard.
    def build_dash_info
      # get routes of application in given namespace, the existing dash_info if exists and the existing routes
      # to the dashboard, if already exists
      @routes = get_namespace_routes file_path
      @dash_info = existing_dash_info

      # remove invalid routing tiles
      remove_invalid_tiles

      # remove route to dashboard itself, if exists
      remove_self_route

      # filter already defined routes in dash_info
      remove_already_defined_routes

      # categiory for new routes
      new_category = {
        label: 't(:\'ez_on_rails.category\')',
        tiles: []
      }

      # Add entry of new routes
      @routes.each do |route|
        # get label for text and label
        model_class = resource_from_route(route)
        default_label = "#{model_class}.model_name.human(count: 2)" if model_class
        default_label = "t(:#{remove_namespaces(route.defaults[:controller])})" unless model_class

        # create tile
        new_category[:tiles].push(
          label: default_label,
          background_color: '#f8f9fa',
          text_color: '#000000',
          text: default_label,
          controller: route.defaults[:controller],
          action: route.defaults[:action]
        )
      end

      # add new tiles to existing dash_info
      @dash_info.push new_category unless new_category[:tiles].empty?

      # remove empty categories
      remove_empty_categories
    end

    # Generates the controller of the dashboard.
    def generate_controller
      template 'controller.rb.erb', File.join('app/controllers', file_path, 'dashboard_controller.rb')
    end

    # Generates the view of the dashboard.
    def generate_view
      template 'index.html.slim.erb', File.join('app/views', file_path, 'dashboard', 'index.html.slim')
    end

    # Generates the view of the dashboard.
    def generate_helper
      template 'helper.rb.erb', File.join('app/helpers', file_path, 'dashboard_helper.rb')
    end

    # Generates the locale files for this scaffold.
    def generate_locale_files
      template 'locale.en.yml.erb', File.join('config/locales', file_path, "#{file_name}.en.yml")
      template 'locale.de.yml.erb', File.join('config/locales', file_path, "#{file_name}.de.yml")
    end

    # Generates the spec files.
    def generate_specs
      template 'request_spec.rb.erb',  File.join('spec/requests', file_path, "dashboard_spec.rb")
    end

    # Adds the restriction records to the seed.
    def add_restrictions_to_seed
      append_to_file 'db/seeds.rb', "
# Restrict access to access #{class_name} dashboard
EzOnRails::GroupAccess.find_or_create_by! group: super_admin_group, namespace: '#{class_name.underscore }', controller: 'dashboard' do |access|
  access.group = super_admin_group
  access.namespace = '#{class_name.underscore }'
  access.controller = 'dashboard'
  access.owner = super_admin_user
end

"
    end

    # Adds the route to the dashboard
    def add_to_routes_rb
      add_routes(["get 'dashboard/', to: 'dashboard#index'"], file_path.split('/'))
    end

    private

    # Returns the existing dash_info of the dashboard, if it already exists.
    # If the dashboard does not exist yet, an empty array will be returned.
    def existing_dash_info
      dashboard_name = "#{class_name}::DashboardHelper"
      dashboard_helper = Module.const_get(dashboard_name) if Module.const_defined?(dashboard_name)
      dash_info_method = "dash_info_#{singular_table_name}".to_sym

      if dashboard_helper&.respond_to? dash_info_method
        return dashboard_helper.module_eval(method_content(dashboard_helper, dash_info_method))
      end

      []
    end

    # Returns the existing routes of the given dashboard, if it already exists.
    # If the dashboard does not exist yet, an empty array will be returned.
    def existing_dashboard_routes(dash_info)
      dashboard_routes = []

      # get routes
      dash_info.each do |category|
        dashboard_routes += category[:tiles].map do |tile|
          {
            controller: tile[:controller],
            action: tile[:action]
          }
        end
      end

      # return result
      dashboard_routes
    end

    # Remopves the tiles from the current dash_info, targeting some non existing route.
    def remove_invalid_tiles
      @dash_info.each do |category|
        category[:tiles].each do |tile|
          category[:tiles] -= [tile] unless route_hash_exists_in? @routes, tile
        end
      end
    end

    # Removes the categories from the current dash_info, having no tiles.
    def remove_empty_categories
      @dash_info.each do |category|
        @dash_info -= [category] if category[:tiles].empty?
      end
    end

    # removes the route to the dashboard itselfs from the routes.
    def remove_self_route
      self_controller = "#{file_path}/dashboard"
      self_action = 'index'

      @routes.each do |route|
        @routes -= [route] if route.defaults[:controller] == self_controller && route.defaults[:action] == self_action
      end
    end

    # removes the routes which are already defined in this dashboard.
    def remove_already_defined_routes
      dashboard_routes = existing_dashboard_routes @dash_info

      @routes.reject! do |route|
        dashboard_routes.any? do |dash_route|
          route.defaults[:controller] == dash_route[:controller] && route.defaults[:action] == dash_route[:action]
        end
      end
    end
  end
end
