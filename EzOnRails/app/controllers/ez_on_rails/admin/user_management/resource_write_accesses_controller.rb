# frozen_string_literal: true

# Controller for a EzOnRails::GroupAccess resource.
class EzOnRails::Admin::UserManagement::ResourceWriteAccessesController <
    EzOnRails::Admin::UserManagement::UserManagementResourceController
  include EzOnRails::Admin::UserManagement::ResourceWriteAccessesHelper

  load_and_authorize_resource class: EzOnRails::ResourceWriteAccess

  self.model_class = EzOnRails::ResourceWriteAccess
  before_action :breadcrumb_resource_write_accesses

  protected

  # Sets the breadcrumb to the index page of this controllers resource..
  def breadcrumb_resource_write_accesses
    breadcrumb self.class.model_class.model_name.human(count: 2),
               controller: '/ez_on_rails/admin/user_management/resource_write_accesses',
               action: 'index'
  end
end
