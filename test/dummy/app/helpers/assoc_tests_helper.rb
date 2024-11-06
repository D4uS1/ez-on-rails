# frozen_string_literal: true

# Helper module for AssocTest resource.
module AssocTestsHelper
  # Returns the render information for the AssocTest resource.
  def render_info_assoc_test
    {
      bearer_token_access_test: {
        label: AssocTest.human_attribute_name(:bearer_token_access_test)
      },
      parent_form_test: {
        label: AssocTest.human_attribute_name(:parent_form_test)
      }
    }
  end
end
