# frozen_string_literal: true

# Helper module for theEzOnRails:: EzOnRails::ResourceWriteAccess resource.
module EzOnRails::Admin::UserManagement::ResourceWriteAccessesHelper
  # Returns the render information for the EzOnRails::ResourceWriteAccess resource.
  def render_info_resource_write_access
    {
      group: {
        label: EzOnRails::ResourceWriteAccess.human_attribute_name(:group),
        label_method: :name
      },
      resource_id: {
        label: EzOnRails::ResourceWriteAccess.human_attribute_name(:resource_id)
      },
      resource_type: {
        label: EzOnRails::ResourceWriteAccess.human_attribute_name(:resource_type)
      }
    }
  end
end
