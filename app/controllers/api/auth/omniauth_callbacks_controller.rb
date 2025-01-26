# frozen_string_literal: true

# Manages callbacks for oauth application.
#
# Overwrites the default behavior of devise_token_auth because we want the user to accept
# the privacy policy before its user is created.
# First the action reads all necessary information and saves it to session variables.
# If the user already exists, the redirect to the success callback will be done directly.
# Otherwise the user object is only build and the action will render the view to accept the privacy policy.
# If the user submits the form, an action in the registration_controller will be called that checks whether
# the privacy policy was accepted. if not he will stay on the form page. Otherwise, he will be redirected to
# the successful callback that is given via devise omniauth.
class Api::Auth::OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController
  # Called after the user did successfully sign in into some omniauth provider.
  # Checks wether the user exists. If yes, he will be redirected to the successfull callback.
  # Otherwise the object will be build and the page for accepting the privacy policy will be rednered.
  # The redirect_route for successfull login is passed to the form.
  def redirect_callbacks
    # derive target redirect route from 'resource_class' param, which was set
    # before authentication.
    provider = params[:provider] # omniauth provider needed to identify the redirect route for successful login
    redirect_route = "omniauth/#{provider}/callback"

    ## preserve omniauth info for success route. ignore 'extra' in twitter
    ## auth response to avoid CookieOverflow.
    session['dta.omniauth.auth'] = request.env['omniauth.auth'].except('extra')
    session['dta.omniauth.params'] = request.env['omniauth.params']

    # try to find user from omniauth info
    @user = User.from_omniauth(request.env['omniauth.auth'])

    # if user eixts, just sign in
    if @user.persisted?
      redirect_to redirect_route
    # if user does not exists, redirect to page to accept privacy policy
    else
      render 'users/registrations/omniauth_sign_up/', locals: { resource: @user, redirect_route: }
    end
  end

  # Called after the login was successfull.
  # Tis method overrides the default behavior of devise_token_auth.
  # The user will not be saved here, because it is expected to be saved after he did accept the privacy policy.
  def omniauth_success
    get_resource_from_auth_hash
    set_token_on_resource
    create_auth_params

    if confirmable_enabled?
      # don't send confirmation email!!!
      @resource.skip_confirmation!
    end

    sign_in(:user, @resource, store: false, bypass: false)

    yield @resource if block_given?

    render_data_or_redirect('deliverCredentials', @auth_params.as_json, @resource.as_json)
  end

  protected

  # Returns the window type that is called after the request was sucessfull.
  # Overwrites the default behavior and adds the window type, if it is not available from
  # the omniauth.params.
  def omniauth_window_type
    omniauth_params['omniauth_window_type'] || 'newWindow'
  end
end
