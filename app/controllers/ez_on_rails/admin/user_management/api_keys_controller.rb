# frozen_string_literal: true

# Controller for a EzOnRails::ApiKey resource.
class EzOnRails::Admin::UserManagement::ApiKeysController <
  EzOnRails::Admin::UserManagement::UserManagementResourceController
  include EzOnRails::Admin::UserManagement::ApiKeysHelper

  load_and_authorize_resource class: EzOnRails::ApiKey

  self.model_class = EzOnRails::ApiKey
  before_action :breadcrumb_api_keys

  protected

  # Sets the breadcrumb to the index action of the controllers resource.
  def breadcrumb_api_keys
    breadcrumb self.class.model_class.model_name.human(count: 2),
               controller: '/ez_on_rails/admin/user_management/api_keys',
               action: 'index'
  end
end
