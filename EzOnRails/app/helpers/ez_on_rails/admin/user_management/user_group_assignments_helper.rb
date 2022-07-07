# frozen_string_literal: true

# Helper module for the EzOnRails::UserGroupAssignment resource.
module EzOnRails::Admin::UserManagement::UserGroupAssignmentsHelper
  # Returns the render information for the EzOnRails::UserGroupAssignment resource.
  def render_info_user_group_assignment
    {
      user: {
        label: EzOnRails::UserGroupAssignment.human_attribute_name(:user),
        label_method: :email
      },
      group: {
        label: EzOnRails::UserGroupAssignment.human_attribute_name(:group),
        label_method: :name
      },
      resource_type: {
        label: EzOnRails::UserGroupAssignment.human_attribute_name(:resource_type)
      },
      resource_id: {
        label: EzOnRails::UserGroupAssignment.human_attribute_name(:resource_id)
      }
    }
  end
end
