# frozen_string_literal: true

# Helper module for NestedFormTest resource.
module NestedFormTestsHelper
  # Returns the render information for the NestedFormTest resource.
  def render_info_nested_form_test
    {
      test_string: {
        nested: true,
        label: NestedFormTest.human_attribute_name(:test_string)
      },
      test_int: {
        nested: true,
        label: NestedFormTest.human_attribute_name(:test_int)
      },
      test_bool: {
        nested: true,
        label: NestedFormTest.human_attribute_name(:test_bool)
      },
      image: {
        nested: true,
        label: NestedFormTest.human_attribute_name(:image)
      },
      parent_form_test: {
        label: NestedFormTest.human_attribute_name(:parent_form_test)
      }
    }
  end
end
