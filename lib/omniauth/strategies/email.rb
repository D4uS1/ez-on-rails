# frozen_string_literal: true

require 'omniauth-oauth2'

# Omniauth strategy for authenticating users via oauth against the users of this application.
# This is called Email strategy because devise_token_auth treats users registered by the application
# as being from the email provider.
class OmniAuth::Strategies::Email < OmniAuth::Strategies::OAuth2
  DOORKEEPER_REQUEST_BASE_URL = if ENV['REQUEST_BASE_URL']
                                  ENV['REQUEST_BASE_URL']
                                else
                                  Rails.env.test? ? 'http://web:3001' : 'http://localhost:3000'
                                end

  option :name, :email

  option :client_options,
         site: DOORKEEPER_REQUEST_BASE_URL,
         authorize_url: '/oauth/authorize'

  uid { raw_info['email'] }

  info do
    {
      email: raw_info['email']
    }
  end

  # Returns the user information and saves it to the instance variable @raw_info.
  # This is needed by the oauth2 strategy.
  def raw_info
    @raw_info ||= access_token.get('/api/auth/email_users/profile.json').parsed
  end

  # Returns the callback url which is needed by the oauth2 strategy.
  def callback_url
    full_host + script_name + callback_path
  end
end
