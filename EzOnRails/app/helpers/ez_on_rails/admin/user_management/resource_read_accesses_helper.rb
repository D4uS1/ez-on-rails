# frozen_string_literal: true

# Helper module for theEzOnRails:: EzOnRails::ResourceReadAccess resource.
module EzOnRails::Admin::UserManagement::ResourceReadAccessesHelper
  # Returns the render information for the EzOnRails::ResourceReadAccess resource.
  def render_info_resource_read_access
    {
      group: {
        label: EzOnRails::ResourceReadAccess.human_attribute_name(:group),
        label_method: :name
      },
      resource_id: {
        label: EzOnRails::ResourceReadAccess.human_attribute_name(:resource_id)
      },
      resource_type: {
        label: EzOnRails::ResourceReadAccess.human_attribute_name(:resource_type)
      }
    }
  end
end
