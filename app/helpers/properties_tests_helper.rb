# frozen_string_literal: true

# Helper module for PropertiesTest resource.
module PropertiesTestsHelper
  # Returns the render information for the PropertiesTest resource.
  def render_info_properties_test
    {
      string_value: {
        label: PropertiesTest.human_attribute_name(:string_value)
      },
      integer_value: {
        label: PropertiesTest.human_attribute_name(:integer_value)
      },
      float_value: {
        label: PropertiesTest.human_attribute_name(:float_value)
      },
      date_value: {
        label: PropertiesTest.human_attribute_name(:date_value)
      },
      datetime_value: {
        label: PropertiesTest.human_attribute_name(:datetime_value)
      },
      boolean_value: {
        label: PropertiesTest.human_attribute_name(:boolean_value)
      },
      assoc_test: {
        label: PropertiesTest.human_attribute_name(:assoc_test)
      }
    }
  end
end
