# frozen_string_literal: true

# Helper module for ValidationErrorTest resource.
module ValidationErrorTestsHelper
  # Returns the render information for the ValidationErrorTest resource.
  def render_info_validation_error_test
    {
      name: {
        label: ValidationErrorTest.human_attribute_name(:name)
      },
      number: {
        label: ValidationErrorTest.human_attribute_name(:number)
      }
    }
  end
end
