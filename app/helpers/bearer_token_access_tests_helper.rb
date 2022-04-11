# frozen_string_literal: true

# Helper module for BearerTokenAccessTest resource.
module BearerTokenAccessTestsHelper
  # Returns the render information for the BearerTokenAccessTest resource.
  def render_info_bearer_token_access_test
    {
      test: {
        label: BearerTokenAccessTest.human_attribute_name(:test)
      },
      owner: {
        label: BearerTokenAccessTest.human_attribute_name(:owner)
      },
      file: {
        label: 'Datei'
      },
      images: {
        type: :images,
        data: {
          max_size: 3000000
        },
        label: 'bilder',
        hide: [:search_form]
      }
    }
  end
end
