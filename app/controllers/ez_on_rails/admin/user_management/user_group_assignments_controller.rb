# frozen_string_literal: true

# Controller for an EzOnRails::UserGroupAssignment resource.
class EzOnRails::Admin::UserManagement::UserGroupAssignmentsController <
    EzOnRails::Admin::UserManagement::UserManagementResourceController
  include EzOnRails::Admin::UserManagement::UserGroupAssignmentsHelper

  load_and_authorize_resource class: EzOnRails::UserGroupAssignment

  self.model_class = EzOnRails::UserGroupAssignment
  before_action :breadcrumb_user_group_assigmnets

  protected

  # Sets the breadcrumb to the index page of this controllers resource.
  def breadcrumb_user_group_assigmnets
    breadcrumb self.class.model_class.model_name.human(count: 2),
               controller: '/ez_on_rails/admin/user_management/user_group_assignments',
               action: 'index'
  end
end
