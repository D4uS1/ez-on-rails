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
  before_action :invalid_request_type, unless: -> { request.format.json? }
  before_action :invalid_api_version, unless: -> { request.headers['api-version'] == API_VERSION }
  rescue_from EzOnRails::ApiError, with: proc { |error| handle_api_error(error) }
  respond_to :json

  # Skips the current request and returns status code 406 for not acceptable
  # request type. This is for instance called by a filter that checks wether
  # the request was send in json or not.
  def invalid_request_type
    raise EzOnRails::InvalidRequestTypeError
  end

  # Skips the current request and returns status code 410 for not anymore available
  # request, because the api version of the client differs from the version used
  # on the server.
  def invalid_api_version
    raise EzOnRails::InvalidVersionError
  end

  # Handles the given raised api error.
  # Renders the error json view file having the http status given by the error.
  def handle_api_error(error)
    render 'ez_on_rails/api/error', locals: { error: }, status: error.http_status
  end

  private

  # Overwrites the behavior of authenticate_user! of device, to return
  # an ez_on_rails error conform json if the user is not signed in.
  def authenticate_user!
    return if current_user

    raise EzOnRails::UnauthorizedError
  end
end
