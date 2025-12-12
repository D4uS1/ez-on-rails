# frozen_string_literal: true

# Helper module for JsonSchemaValidatorTest resource.
module JsonSchemaValidatorTestsHelper
  # Returns the render information for the JsonSchemaValidatorTest resource.
  def render_info_json_schema_validator_test
    {
      test: {
        type: :json,
        label: JsonSchemaValidatorTest.human_attribute_name(:test)
      }
    }
  end
end
