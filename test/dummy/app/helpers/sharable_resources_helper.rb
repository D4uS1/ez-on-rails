# frozen_string_literal: true

# Helper module for SharableResource resource.
module SharableResourcesHelper
  # Returns the render information for the SharableResource resource.
  def render_info_sharable_resource
    {
      test: {
        label: SharableResource.human_attribute_name(:test)
      },
      read_accessible_groups: {
        label: t(:'ez_on_rails.ownership_info.read_accessible'),
        label_method: :name
      },
      write_accessible_groups: {
        label: t(:'ez_on_rails.ownership_info.write_accessible'),
        label_method: :name
      },
      destroy_accessible_groups: {
        label: t(:'ez_on_rails.ownership_info.destroy_accessible'),
        label_method: :name
      }
    }
  end
end
