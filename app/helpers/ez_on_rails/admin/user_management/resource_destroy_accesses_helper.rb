# frozen_string_literal: true

# Helper module for theEzOnRails:: EzOnRails::ResourceDestroyAccess resource.
module EzOnRails::Admin::UserManagement::ResourceDestroyAccessesHelper
  # Returns the render information for the EzOnRails::ResourceDestroyAccess resource.
  def render_info_resource_destroy_access
    {
      group: {
        label: EzOnRails::ResourceDestroyAccess.human_attribute_name(:group),
        label_method: :name
      },
      resource_id: {
        label: EzOnRails::ResourceDestroyAccess.human_attribute_name(:resource_id)
      },
      resource_type: {
        label: EzOnRails::ResourceDestroyAccess.human_attribute_name(:resource_type)
      }
    }
  end
end
