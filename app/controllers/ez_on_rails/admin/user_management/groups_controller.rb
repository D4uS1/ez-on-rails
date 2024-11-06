# frozen_string_literal: true

# Controller for a EzOnRails::Group resource.
class EzOnRails::Admin::UserManagement::GroupsController <
    EzOnRails::Admin::UserManagement::UserManagementResourceController
  include EzOnRails::Admin::UserManagement::GroupsHelper

  load_and_authorize_resource class: EzOnRails::Group

  self.model_class = EzOnRails::Group
  before_action :breadcrumb_groups

  protected

  # Sets the breadcrumb to the index action of the controllers resource.
  def breadcrumb_groups
    breadcrumb self.class.model_class.model_name.human(count: 2),
               controller: '/ez_on_rails/admin/user_management/groups',
               action: 'index'
  end
end
