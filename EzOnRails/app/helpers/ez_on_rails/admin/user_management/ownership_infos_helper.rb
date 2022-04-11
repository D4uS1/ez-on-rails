# frozen_string_literal: true

# Helper module for EzOnRails::OwnershipInfo resources.
module EzOnRails::Admin::UserManagement::OwnershipInfosHelper
  # Returns the render information for the EzOnRails::OwnershipInfo resource.
  def render_info_ownership_info
    {
      resource: {
        label: EzOnRails::OwnershipInfo.human_attribute_name(:resource)
      },
      sharable: {
        label: EzOnRails::OwnershipInfo.human_attribute_name(:sharable)
      },
      on_owner_destroy: {
        label: EzOnRails::OwnershipInfo.human_attribute_name(:on_owner_destroy),
        type: :enum
      }
    }
  end
end
