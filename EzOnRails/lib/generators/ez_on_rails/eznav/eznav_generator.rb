# frozen_string_literal: true

require 'rails/generators'
require 'helper/ez_on_rails/route_helper'
require 'helper/ez_on_rails/pretty_print_helper'

module EzOnRails
  # Generates the Navigation Bar Menu depending on the existing controllers and actions.
  # Please read the README file for further information.
  class EznavGenerator < Rails::Generators::Base
    include ::EzOnRails::RouteHelper
    include ::EzOnRails::PrettyPrintHelper
    include EzOnRails::EzNavHelper
    include EzOnRails::MenuStructureHelper

    source_root File.expand_path('templates', __dir__)

    # Defines the controllers which should not be in the menu navigation.
    EXCLUDED_CONTROLLERS = [
      'contact_form',
      'error',
      'imprint',
      'privacy_policy',
      'welcome'
    ].freeze

    EXCLUDED_NAMESPACES = [
      'action_mailbox',
      'active_storage',
      'api',
      'devise_token_auth',
      'doorkeeper',
      'ez_on_rails',
      'users',
      'rails'
    ].freeze

    # Reads the current menu structure and writes it to a local instance variable.
    def read_current_menu
      @new_menu_structure = EzOnRails::MenuStructureHelper.module_eval method_content(EzOnRails::MenuStructureHelper, :menu_structure)
    end

    # Gets all defined routes defined by a controller and action and writes them into an array
    # saved in the instance variable @routes. All routes except the ones having the controller which is defined
    # in the EXCLUDED_CONTROLLERS constant will be saved.
    # The routes array is divided into controller elements. Those controller elements contain the actions.
    # If the controller has got an index action, only the index action will be registered. This is because
    # in this case this should be a ressource and a ressource should be designed to get all actions to that ressource
    # accessible from the index page.
    def all_routes
      @routes = []

      Rails.application.routes.routes.map do |route|
        controller = route.defaults[:controller]

        # controller not found
        next if !controller

        # if the controller is not excluded
        next if EXCLUDED_CONTROLLERS.include?(controller)

        # if the namespace is not excluded
        next if EXCLUDED_NAMESPACES.any? { |excluded_ns| controller.starts_with? excluded_ns }

        # specifiy the index route if exists
        index_route = get_index_route_entry controller
        route = index_route if index_route

        # if the controller does not already exist in the routes, create it
        @routes.push route unless route_exists_in? @routes, route
      end
    end

    # Writes the routes into the global navigation structure configuration.
    # Existing routes will not be overwritten.
    # Also removes routes who does not exist anymore
    def create_navigation
      # Add the route to the menu structure
      @routes.each do |route|
        add_menu_structure_entry route
      end

      # remove non existing routes
      remove_invalid_routes

      # remove empty submenus
      remove_empty_menus
    end

    # Adds the navigation entries for administration area.
    def append_administration
      return if get_menu_structure_ns_entry 'ez_on_rails/admin'

      # append main_menu
      @new_menu_structure[:main_menus].push({
        label: "t(:'ez_on_rails.administration')",
        namespace: 'ez_on_rails/admin',
        sub_menus: []
      })

      # append sub_menus
      @new_menu_structure[:main_menus].last[:sub_menus].push({
          controller: 'ez_on_rails/admin/dashboard',
          action: 'index',
          label: "t(:'ez_on_rails.dashboard')",
          invisible: false
      })
      @new_menu_structure[:main_menus].last[:sub_menus].push({
        controller: 'ez_on_rails/admin/user_management/dashboard',
        action: 'index',
        label: "t(:'ez_on_rails.user_management')",
        invisible: false
      })
      @new_menu_structure[:main_menus].last[:sub_menus].push({
        controller: 'ez_on_rails/admin/broom_closet/dashboard',
        action: 'index',
        label: "t(:'ez_on_rails.broom_closet')",
        invisible: false
      })
    end

    # Writes the current MENU_STRUCTURE object to the config.
    def write_menu_structure
      template 'menu_structure_helper.rb.erb', 'app/helpers/ez_on_rails/menu_structure_helper.rb'
    end

    # print the message to restart the server
    def print_message
      print "Your navigation has been updated successfully.\n"
    end

    private

    # Returns the menu entry of the specified namespace, controller and action.
    # Returns nil if no entry was found.
    def get_menu_structure_entry(namespace, controller, action)
      search_menus = @new_menu_structure[:main_menus]
      if namespace
        namespace_entry = get_menu_structure_ns_entry namespace

        # if namespace is specified, but namespace entry does not exists, the menu entry does not exists
        return nil unless namespace_entry

        search_menus = namespace_entry[:sub_menus]
      end

      # Search for the action and controller in the menus
      search_menus.each do |menu|
        return menu if (menu[:controller] == controller) && (menu[:action] == action)
      end

      nil
    end

    # Returns the menu entry of the specified namespace, if exists.
    def get_menu_structure_ns_entry(namespace)
      @new_menu_structure[:main_menus].each do |menu|
        return menu if menu[:namespace] && (menu[:namespace] == namespace)
      end

      nil
    end

    # Adds a default entry for the specified namespace, controller and action to the menu.
    # If no namespace is specified, the entry will be placed in the main menus entries.
    # If a namespace is specified and already exists, the controller and action will be placed in the
    # namespace. Otherwise a namespace will be created.
    # If the controller and action already exist, the entry will not be replaced.
    def add_menu_structure_entry(route)
      controller = route.defaults[:controller]
      action = route.defaults[:action]
      namespace = get_first_namespace route

      # if the entry already exists, do nothing
      return if get_menu_structure_entry namespace, controller, action

      # get label for menu entry
      model_class = resource_from_route(route)
      default_label = "#{model_class}.model_name.human(count: 2)" if model_class
      default_label = "t(:#{remove_namespaces(route.defaults[:controller])})" unless model_class

      # build menu entry
      menu_entry = {
        controller: controller,
        action: action,
        label: default_label,
        invisible: false
      }

      # create namespace entry, if not exists
      if namespace && (!get_menu_structure_ns_entry namespace)
        @new_menu_structure[:main_menus].insert(0,
                                                label: "t(:#{remove_namespaces(namespace)})",
                                                namespace: namespace,
                                                sub_menus: [])
      end

      # place menu at the correct position
      if namespace
        namespace_entry = get_menu_structure_ns_entry namespace
        namespace_entry[:sub_menus].push menu_entry
      else
        @new_menu_structure[:main_menus].insert 0, menu_entry
      end
    end

    # Removes all routes from the existing new menu structure, who are not targeting a valid route.
    def remove_invalid_routes
      @new_menu_structure[:main_menus].each do |main_menu|
        if submenus? main_menu
          main_menu[:sub_menus].each do |sub_menu|
            main_menu[:sub_menus] -= [sub_menu] unless route_hash_exists_in? @routes, sub_menu
          end
        else
          @new_menu_structure[:main_menus] -= [main_menu] unless route_hash_exists_in? @routes, main_menu
        end
      end
    end

    # Removes menu entries having an empty sub_menu entry.
    def remove_empty_menus
      @new_menu_structure[:main_menus].each do |main_menu|
        next unless submenus? main_menu

        @new_menu_structure[:main_menus] -= [main_menu] if main_menu[:sub_menus].empty?
      end
    end
  end
end
