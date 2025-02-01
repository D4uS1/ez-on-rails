# frozen_string_literal: true

# Helper module for working with routes used by the eznav and ezdash generators.
# This helper should only be used by ez_on_rails generators.
module EzOnRails::RouteHelper
  # Returns the entry of the routes of the specified controller where the action
  # is the indecx action. If this action in this controller does not exist,
  # nil will be returned.
  def get_index_route_entry(controller)
    Rails.application.routes.routes.each do |route|
      return route if (route.defaults[:controller] == controller) && (route.defaults[:action] == 'index')
    end

    nil
  end

  # Returns the first namespace of the route, if exists. Returns nil otherwise.
  def get_first_namespace(route)
    if route.defaults[:controller]
      return route.defaults[:controller].split('/').length > 1 ? (route.defaults[:controller].split('/')[0]) : nil
    end

    nil
  end

  # Returns the namespaces of the route as an array.
  # If the route does not contain namespaces, the array will be empty.
  def get_namespaces(route)
    namespaces = []
    if route.defaults[:controller]
      namespaces = route.defaults[:controller].split('/')

      # remove controller itself
      namespaces.pop
    end

    namespaces
  end

  # Returns all routes being in the specified namespace.
  # if some controller contains an index action, only the roiute to the index action will be added.
  def get_namespace_routes(namespace)
    routes = []

    Rails.application.routes.routes.each do |route|
      next unless route_is_in_namespace route, namespace

      # If the controller has an index action, choose this one
      index_route = get_index_route_entry route.defaults[:controller]
      route = index_route if index_route

      # add to the routes list
      routes.push route unless route_exists_in?(routes, route)
    end

    routes
  end

  # Returns true, if the specified route is in the collection of specified routes.
  def route_exists_in?(routes, route)
    routes.any? { |r| r.path == route.path }
  end

  # Returns wether the route_hash, having the values :controller and :action
  # is in the collection of rails routes.
  def route_hash_exists_in?(routes, route_hash)
    routes.any? do |route|
      route.defaults[:controller] == route_hash[:controller] && route.defaults[:action] == route_hash[:action]
    end
  end

  # Returns if the specified route is in the specified full namespace.
  def route_is_in_namespace(route, namespace)
    namespaces = namespace.split('/')
    route_namespaces = get_namespaces route

    # if this routes does not havy any namespaces, it is not in namespace
    return false if route_namespaces.empty? && !namespaces.empty?

    # check every namespace part from the beginning, if any does not match, it is not inside the namespace
    namespaces.each_with_index do |ns, i|
      return false unless ns == route_namespaces[i]
    end

    true
  end

  # removes the namespaces from the specified route text.
  # namespaces are seperated by /. This method will split the route_text into parts
  # of namespaces and will remove all of them, except for the last occurence.
  # Hence the routes last part will be returned.
  def remove_namespaces(route_text)
    route_text.split('/').last
  end

  # Returns an array of lines compatible to the route rb, surrouned by a locale.
  # The givgen routes and namespaces are epxected to be arrays of strings.
  # if skip_locale is true, the locale scope will not te be added.
  # if json is true, the routes will be surrounded by a constraint that only allowes the requests
  # to be in json format.
  def routes_rb_lines(routes, namespaces, skip_locale: false, json: false)
    depth = 0
    lines = []

    # scope for only json request
    if json
      lines << "scope constraints: lambda { |req| req.format == :json } do\n"
      depth += 2
    end

    # Scope for language switch
    unless skip_locale
      lines << "scope '(:locale)', locale: /en|de/ do\n"
      depth += 2
    end

    # Create 'namespace' ladder
    namespaces.each do |ns|
      lines << indent("namespace :#{ns} do\n", depth)
      depth += 2
    end

    # Create route
    routes.each do |route|
      lines << indent("#{route}\n", depth)
    end

    until depth.zero?
      depth -= 2
      lines << indent("end\n", depth)
    end

    lines
  end

  # Adds the given routes to the routing file.
  # Routes is exepcetd to be an array of strings.
  # namespaces contains the namespace information, expected as array
  # of strings, too.  All Routes will be surrounded by a locale scope.
  # if skip_locale is true, the lines for locales are ignored.
  # if json is true, the routes are surrounded by a constraint that only allowes the requests to be
  # in json format.
  def add_routes(routes, namespaces, skip_locale: false, json: false)
    route routes_rb_lines(routes, namespaces, skip_locale:, json:).join
  end

  # Returns the active record resource class of the correpsonding
  # controller targeted by the given route.
  # If no resource class exists, nil will be returned.
  def resource_from_route(route)
    parts = route.defaults[:controller].split('/')

    # camelize each part and join, because only camelizing would result in Something::weird instead Something::Weird
    class_name = parts.map(&:camelize).join('::').singularize

    # Try to get the class
    Class.const_get(class_name)
  rescue NameError
    nil
  end
end
