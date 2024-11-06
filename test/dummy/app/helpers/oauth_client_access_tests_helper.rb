# frozen_string_literal: true

# Helper module for OauthClientAccessTest resource.
module OauthClientAccessTestsHelper
  # Returns the render information for the OauthClientAccessTest resource.
  def render_info_oauth_client_access_test
    {
      test: {
        label: OauthClientAccessTest.human_attribute_name(:test)
      }
    }
  end
end
