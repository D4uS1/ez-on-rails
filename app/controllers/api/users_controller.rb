# frozen_string_literal: true

# Contains actions related to users.
class Api::UsersController < EzOnRails::Api::BaseController
  # GET api/users/me
  #
  # Returns the own user information, including email, username and avatar.
  def me
    render 'api/users/me', locals: {
      user: current_user
    }
  end

  # PUT api/users/me
  #
  # Updates the own user information, including email, username and avatar.
  def update_me
    raise EzOnRails::ValidationFailedError, current_user unless current_user.update(update_me_params)

    render 'api/users/me', locals: {
      user: current_user
    }
  end

  private

  # Whitelisting parameters to update the own user profile.
  def update_me_params
    params.expect(user: %i[email password password_confirmation username avatar])
  end
end
