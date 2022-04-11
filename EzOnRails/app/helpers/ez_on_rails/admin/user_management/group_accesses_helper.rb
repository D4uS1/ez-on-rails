# frozen_string_literal: true

# Helper module for theEzOnRails:: EzOnRails::GroupAccess resource.
module EzOnRails::Admin::UserManagement::GroupAccessesHelper
  # Returns the render information for the EzOnRails::GroupAccess resource.
  def render_info_group_access
    {
      group: {
        label: EzOnRails::GroupAccess.human_attribute_name(:group),
        label_method: :name
      },
      namespace: {
        label: EzOnRails::GroupAccess.human_attribute_name(:namespace)
      },
      controller: {
        label: EzOnRails::GroupAccess.human_attribute_name(:controller)
      },
      action: {
        label: EzOnRails::GroupAccess.human_attribute_name(:action)
      }
    }
  end
end
