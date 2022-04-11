# frozen_string_literal: true

# Controller for Resource Controllers in the admin/user_management namespace.
# This controller uses a breadcrumb referencing to the admin/user_management dashboard.
# Hence every resource controller in the admin/user_management namespace should inherit
# from this controller.
class EzOnRails::Admin::UserManagement::UserManagementResourceController < EzOnRails::Admin::AdminResourceController
  before_action :breadcrumb_user_management

  protected

  # Sets the breadcrumb to the User Management dashboard.
  def breadcrumb_user_management
    breadcrumb I18n.t(:'ez_on_rails.user_management'),
               controller: '/ez_on_rails/admin/user_management/dashboard',
               action: 'index'
  end
end
