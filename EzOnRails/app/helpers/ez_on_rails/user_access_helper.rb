# frozen_string_literal: true

# Helper to define some methods for getting user access information.
# The access system is based on users and groups.
# Any user can have many groups.
# Any namespace can have many groups.
# Any controller can have many groups.
# Any action can have many groups.
# If no group assignment for a namespace, controller or action is defined,
# the user can access it.
# Otherwise the system checks wether the current user is in the same group,
# which is assigned to the namespace, controller and action.
#
# A namesapace in this context means some part of the real controllers namespace.
# For instance, if a controller is in the rails namespaces admin/user_management, the namespaces
# for access management are admin and admin/user_management.
# This makes it possible to define some "subparts" of the website a user cannot see.
# For instance, it is possible to give some user admin rights, hence he can view all controllers
# and actions within the admin namespace. But it is possible to forbid the admin/user_management
# section, hence any controller in admin except those in the admin/user_management
# section are accessible.
#
# The access rights are granted upside down. This means if any any action is called,
# the access of the current user to this action will be checked.
# if the user has no access to the action, it will be denied.
# If the user has access to the action, the access to the controller containing that action will be checked.
# If the user has no access to that controller, it will be denied.
# If the user has access to that controller, the namespaces will be checked.
# For every namespaces (e.g. admin/user_management and admin) the access will be checked.
# If the user has no acces to the namespace, it will be denied.
# If the user has access to the namespace, it will be granted.
#
# Another important part is the possibility to have ownership infos.
# If a resource is specified in the table of ownership_infos, the ability to
# access this resource is checked, wenether a user tries to access it.
# In this case only the owner of the resource (user attribute or the ressource), can view or edit it.
# If the resource has no user (nil), the access will also be granted.
module EzOnRails::UserAccessHelper
  # Checks if the current user has access to the specified action of the specified controller
  # in the specified namespace.
  # If the user does not have access and is not logged in, he will be redirected to the login page.
  # If the user has no access and is logged in, the user will be redirected to the no Access Error Page.
  # For more information about the access system, read the module description.
  def check_access_to_action(namespace, controlller, action)
    # If the user has access, we do not need to perform further actions
    return if access_to_action? namespace, controlller, action

    # If the user is signed in, he has no access, because he was rejected before
    return access_denied if user_signed_in?

    # Try to login the user, first store the current location if this is an get request
    if request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
      store_location_for(:user, request.fullpath)
    end

    # Request login
    authenticate_user!
  end

  # Checks if the current user has access to the current called page.
  # If the user does not have access and is not logged in, he will be redirected to the login page.
  # If the user has no access and is logged in, the user will be redirected to the no Access Error Page.
  # For more information about the access system, read the module description.
  def check_access_to_current_page
    return if params[:controller].nil? # the controller param is nil if this is the omniauth callback controller

    namespace = get_top_namespace params[:controller]
    controller = get_controller params[:controller]

    check_access_to_action namespace, controller, params[:action]
  end

  # Checks wether the current user has access to the given namespace.
  # Note, that not only the rights for the namespace will be checked.
  # All namespaces containing the given namespace will be checked, too.
  # For instance, if the namespace is ns1/ns2, this method will check the access for
  # ns1/ns2 and ns1.
  # For more information about the access system, read the module description.
  def access_to_namespace?(namespace)
    access_to?(namespace, nil, nil)
  end

  # Checks wether the current user has access to the given controller in the given namespace.
  # Note, that not only the rights for the controller will be checked.
  # The rights to the controller and all namespaces containing the given namespace will be checked, too.
  # For more information about the access system, read the module description.
  def access_to_controller?(namespace, controller)
    access_to?(namespace, controller, nil)
  end

  # Checks wether the current user has access to the given action of the  controller in the given namespace.
  # Note, that not only the rights for the action will be checked.
  # The rights to the action, the controller and all namespaces containing the given namespace will be checked, too.
  # If nil is given for the action, only the controller and namespac accesses will be checked.
  # If nil is given for the action and controller, only the access to the namespace will be checked.
  # For more information about the access system, read the module description.
  def access_to_action?(namespace, controller, action)
    access_to?(namespace, controller, action)
  end

  # This method takes the path of the controller including the namespaces and will check the
  # access of the current user.
  # e.G. if the controller contains namespaces like ns1/ns2/controller1, this method can be used.
  # For more information about the access system, read the module description.
  def access_to_action_in_path?(controller_path, action)
    namespace = get_top_namespace controller_path
    controller = get_controller controller_path
    access_to_action? namespace, controller, action
  end

  # Returns wether the current user has access to the given path.
  # For more information about the access system, read the module description.
  def access_to_url?(url)
    path = Rails.application.routes.recognize_path url
    access_to_action_in_path? path[:controller], path[:action]
  end

  # Redirects the user to the Error Page for Access denied error.
  def access_denied
    if request.format.json?
      error = EzOnRails::ForbiddenError.new
      return render 'ez_on_rails/api/error', locals: { error: error }, status: error.http_status
    end

    flash[:alert] = t(:'ez_on_rails.access_denied_message')
    render 'ez_on_rails/errors/403', status: :forbidden
  end

  private

  # Checks wether the specified action in the specified controller of the specified namespace
  # has any group assignments. If not, the access to any user will be granted and the method
  # will return true. Otherwise the access will be evaluated, hence:
  # if the user is not logged in, this method will return false.
  # if the user has no group assignment to any group which has access to the namespace, this method
  # will return false.
  # This method should only be used inside the access module. It only checks the direct access information.
  # For instance, if a group admin exists and this group has access to the namespace admin and the access right
  # for some action will be checked with this method, it will return true. This is because there exists no
  # group assignment for the specified action and controller and namespace.
  def access_to?(namespace, controller, action)
    # admin can access everything
    return true if current_user&.super_admin?

    # check access for action, if defined
    if action && restricted_area?(namespace, controller, action)
      return user_can_access? current_user, namespace, controller, action
    end

    # check access for controller, if defined
    if controller && restricted_area?(namespace, controller, nil)
      return user_can_access? current_user, namespace, controller, nil
    end

    # check access for all namespaces, if defined
    if namespace
      namespaces = get_all_namespaces namespace
      namespaces.each do |ns|
        return user_can_access?(current_user, ns, nil, nil) if restricted_area?(ns, nil, nil)
      end
    end

    true
  end

  # Checks wether the given namespace, controller and action defines some restricted area. Hence,
  # checks wether some group assignment exists to the specified namespace, controller
  # and action. The values can be nil, hence it is possible to check wether some group assignments
  # exists for namespaces or controllers e.g.
  def restricted_area?(namespace, controller, action)
    get_access_groups(namespace, controller, action).any?
  end

  # Returns the groups having access to the specified namespace, controller and action.
  def get_access_groups(namespace, controller, action)
    namespace = namespace.join('/') if namespace.is_a?(Array)

    EzOnRails::GroupAccess.where(namespace: namespace, controller: controller, action: action).map(&:group)
  end

  # returns wether the specified user is in at least one of the specified groups.
  def user_in_groups?(user, groups)
    EzOnRails::UserGroupAssignment.where(user: user, group: groups).any?
  end

  # returns wether the specified user can access the defined
  # This method only returns only if the user can access the specified combination of namespace,
  # controller and action. Hence, this method only should be used by internal proposes.
  def user_can_access?(user, namespace, controller, action)
    user_in_groups?(user, get_access_groups(namespace, controller, action))
  end

  # returns the top namespace of the specified controller path.
  # e.G. the namespace of example1/example2/controller1#index will be example1/example2
  # if the controller does not have any namespaces, nil will be returned
  def get_top_namespace(controller_path)
    splits = controller_path.split('/')
    return nil if splits.count < 2

    splits.pop
    splits.join('/')
  end

  # Returns all namespaces within the spefieid full namespace.
  # This means, if e.g. a given namespace is ns1/ns2, this
  # method will return an array containing the strings "ns1/ns2" and "ns1".
  # If the controller path has no namespaces, nil will be returned.
  def get_all_namespaces(namespace)
    return [] unless namespace

    parts =  namespace.split('/')

    # build result
    result = []
    (0..(parts.length - 1)).reverse_each do |i|
      result.push parts[0..i]
    end

    result
  end

  # returns the controller of the specified controller path.
  #  e.G. the controller of example1/example2/controller1#index will be controller1.
  def get_controller(controller_path)
    controller_path.split('/').last
  end

  # returns wether the current user has the ability to view the given resource
  def access_to_show_resource?(resource)
    can? :show, resource
  end

  # returns wether the current user has the ability to edit the given resource
  def access_to_edit_resource?(resource)
    can? :edit, resource
  end

  # returns wether the current user has the ability to destroy the given resource.
  def access_to_destroy_resource?(resource)
    can? :destroy, resource
  end

  # returns wether the current user has the ability to manage(view, edit, destroy) the given resource.
  def access_to_manage_resource?(resource)
    can? :manage, resource
  end
end
