# frozen_string_literal: true

# Helper module for ApiKeyTest resource.
module ApiKeyTestsHelper
  # Returns the render information for the ApiKeyTest resource.
  def render_info_api_key_test
    {
      test: {
        label: ApiKeyTest.human_attribute_name(:test)
      }
    }
  end
end
