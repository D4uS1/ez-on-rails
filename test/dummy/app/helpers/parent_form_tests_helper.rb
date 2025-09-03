# frozen_string_literal: true

# Helper module for ParentFormTest resource.
module ParentFormTestsHelper
  # Returns the render information for the ParentFormTest resource.
  def render_info_parent_form_test
    {
      test: {
        label: ParentFormTest.human_attribute_name(:test)
      },
      nested_form_tests: {
        type: :nested_form,
        label_method: :test_string,
        data: {
          render_info: render_info_nested_form_test,
          hide_nested_goto: false
        },
        label: ParentFormTest.human_attribute_name(:nested_form_tests),
      },
      test_bool: {
        label: ParentFormTest.human_attribute_name(:test_bool)
      }
    }
  end
end
