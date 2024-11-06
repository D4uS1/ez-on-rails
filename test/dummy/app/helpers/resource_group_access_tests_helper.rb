# frozen_string_literal: true

# Helper module for ResourceGroupAccessTest resource.
module ResourceGroupAccessTestsHelper
  # Returns the render information for the ResourceGroupAccessTest resource.
  def render_info_resource_group_access_test
    {
      test: {
        label: ResourceGroupAccessTest.human_attribute_name(:test)
      }
    }
  end
end
