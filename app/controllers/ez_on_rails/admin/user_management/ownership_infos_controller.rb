# frozen_string_literal: true

# Controller for the EzOnRails::OwnershipInfos resource.
class EzOnRails::Admin::UserManagement::OwnershipInfosController <
    EzOnRails::Admin::UserManagement::UserManagementResourceController
  include EzOnRails::Admin::UserManagement::OwnershipInfosHelper

  load_and_authorize_resource class: EzOnRails::OwnershipInfo

  self.model_class = EzOnRails::OwnershipInfo
  before_action :breadcrumb_ownership_infos

  protected

  # Sets the breadcrumb to the index page of this controllers resource.
  def breadcrumb_ownership_infos
    breadcrumb self.class.model_class.model_name.human(count: 2),
               controller: '/ez_on_rails/admin/user_management/ownership_infos',
               action: 'index'
  end
end
