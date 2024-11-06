# frozen_string_literal: true

# Controller for a EzOnRails::GroupAccess resource.
class EzOnRails::Admin::UserManagement::GroupAccessesController <
    EzOnRails::Admin::UserManagement::UserManagementResourceController
  include EzOnRails::Admin::UserManagement::GroupAccessesHelper

  load_and_authorize_resource class: EzOnRails::GroupAccess

  self.model_class = EzOnRails::GroupAccess
  before_action :breadcrumb_group_accesses

  protected

  # Sets the breadcrumb to the index page of this controllers resource..
  def breadcrumb_group_accesses
    breadcrumb self.class.model_class.model_name.human(count: 2),
               controller: '/ez_on_rails/admin/user_management/group_accesses',
               action: 'index'
  end
end
