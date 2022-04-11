# frozen_string_literal: true

# Controller for a EzOnRails::ResourceReadAccess resource.
class EzOnRails::Admin::UserManagement::ResourceReadAccessesController <
    EzOnRails::Admin::UserManagement::UserManagementResourceController
  include EzOnRails::Admin::UserManagement::ResourceReadAccessesHelper

  load_and_authorize_resource class: EzOnRails::ResourceReadAccess

  self.model_class = EzOnRails::ResourceReadAccess
  before_action :breadcrumb_resource_read_accesses

  protected

  # Sets the breadcrumb to the index page of this controllers resource..
  def breadcrumb_resource_read_accesses
    breadcrumb self.class.model_class.model_name.human(count: 2),
               controller: '/ez_on_rails/admin/user_management/resource_read_accesses',
               action: 'index'
  end
end
