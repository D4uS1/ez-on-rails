# frozen_string_literal: true

# Controller for a EzOnRails::ResourceDestroyAccess resource.
class EzOnRails::Admin::UserManagement::ResourceDestroyAccessesController <
    EzOnRails::Admin::UserManagement::UserManagementResourceController
  include EzOnRails::Admin::UserManagement::ResourceDestroyAccessesHelper

  load_and_authorize_resource class: EzOnRails::ResourceDestroyAccess

  self.model_class = EzOnRails::ResourceDestroyAccess
  before_action :breadcrumb_resource_destroy_accesses

  protected

  # Sets the breadcrumb to the index page of this controllers resource..
  def breadcrumb_resource_destroy_accesses
    breadcrumb self.class.model_class.model_name.human(count: 2),
               controller: '/ez_on_rails/admin/user_management/resource_destroy_accesses',
               action: 'index'
  end
end
