# frozen_string_literal: true

# A base controller class for an api controller.
# The api base controller sets the current user based on the access token delivered by the request.
# This is manages by devise_token_auth.
# The token can be obtained if the user was signed in successfully before.
# This can happen via the auth actions delivery by devise_token_auth or any oauth provider given by this app.
# See the README for further information.
class EzOnRails::Api::BaseController < EzOnRails::ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken

  skip_before_action :verify_authenticity_token
  before_action :invalid_request_type, unless: -> { json_request? }
  before_action :invalid_api_version, unless: -> { request.headers['api-version'] == API_VERSION }
  respond_to :json

  # Skips the current request and returns status code 410 for not anymore available
  # request, because the api version of the client differs from the version used
  # on the server.
  def invalid_api_version
    raise EzOnRails::InvalidVersionError
  end

  private

  # Overwrites the behavior of authenticate_user! of device, to return
  # an ez_on_rails error conform json if the user is not signed in.
  def authenticate_user!
    return if current_user

    raise EzOnRails::UnauthorizedError
  end
end
