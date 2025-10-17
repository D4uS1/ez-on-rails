# frozen_string_literal: true

# Helper module for the EzOnRails::ApiKey resource.
module EzOnRails::Admin::UserManagement::ApiKeysHelper
  # Returns the render information for the EzOnRails::ApiKey resource.
  def render_info_api_key
    {
      api_key: {
        label: EzOnRails::ApiKey.human_attribute_name(:api_key),
        help: t(:'ez_on_rails.api_key_field_help')
      },
      expires_at: {
        label: EzOnRails::ApiKey.human_attribute_name(:expires_at)
      }
    }
  end
end
