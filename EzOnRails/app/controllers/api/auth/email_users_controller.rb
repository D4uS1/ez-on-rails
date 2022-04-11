# frozen_string_literal: true

# Controller for returning information about the current doorkeeper user.
# This is the only controller in the api namespace, that is authenticated against doorkeeper instead
# of devise_token_auth.
# This is because the action to obtain the user information is called from the doorkeeper omniauth strategy.
# At the point where the strategy calls the actionm, the autnetication process was not finished fully yet,
# hence devise_token_auth does not obtain any token and deliveres an unauthorizes status code.
# Hence this controller should not inherit from Api::BaseController because everything in the api namespace
# is authenticated with devise_token_auth.
class Api::Auth::EmailUsersController < EzOnRails::ApplicationController
  before_action :doorkeeper_authorize!

  # GET api/me
  #
  # returns the current doorkeeper user as json.
  # Needed because omniauth strategies does not have access to the current user.
  # Hence they need to call this action to get the user information.
  def profile
    render json: current_resource_owner
  end

  # Returns the current user if the doorkeeper oauth provider was used for authentication.
  # The user is identified by the doorkeeper_token.
  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
