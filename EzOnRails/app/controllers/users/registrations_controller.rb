# frozen_string_literal: true

# Controller for registrations managed by devise.
class Users::RegistrationsController < Devise::RegistrationsController
  # TODO: delete after devise update for Rails 7
  include DeviseTurboConcern

  respond_to :json

  # GET /users/sign_up
  def new
    @subtitle = t(:add_new_user)
    super
  end

  # GET /users/edit
  def edit
    @subtitle = t(:edit_user)
    super
  end

  # PATCH current user
  # Checks wether the user wants to destroy its account or update its account.
  # If he wants to destroy, the destroy action will only be called if the user has typed
  # in the correct password.
  # If he wants to update, the update will be tried after validation.
  # The code for update was copied from the devises parent controller because the devise
  # controller did not return base error messages.
  def update
    return destroy_with_password if params[:commit] == t(:remove_account)

    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      set_flash_message_for_update(resource, prev_unconfirmed_email)
      bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?

      respond_with resource, location: after_update_path_for(resource)
    else
      # Return error
      flash[:danger] = resource.errors[:base].first unless resource.errors[:base].empty?
      if resource.errors[:base].empty?
        flash[:danger] = t(:'ez_on_rails.not_updatable', resource_obj: User.model_name.human)
      end

      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  # POST /users/omniauth_sign_up
  #
  # Saves the user having the omniauth data to the database.
  # This create action is expected to be called after the user accepted the privacy policy after a successfull login
  # via omniauth happened. If it is not possible to save the resource, the user will be redirected to the accepting
  # page again. Otherwise it will be saved and he will be redirected to the redirect_route, that was passed through
  # from the omniauth callbacks over the form to this action.
  def omniauth_create
    build_resource(devise_parameter_sanitizer.sanitize(:omniauth_sign_up))
    redirect_route = params[:redirect_route]

    if resource.save_with_omniauth
      redirect_to params[:redirect_route]
    else
      render 'users/registrations/omniauth_sign_up/', locals: { resource: resource, redirect_route: redirect_route }
    end
  end

  protected

  # DELETE /resource
  # Destroys the resource only if the correct password is passed.
  # If the current user is the superadmin, it is not destroyable.
  def destroy_with_password
    # destroy if possible
    if resource.destroy_with_password account_update_params[:current_password]
      Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
      set_flash_message! :notice, :destroyed
      yield resource if block_given?
      respond_with_navigational(resource) { redirect_to after_sign_out_path_for(resource_name) }
    else
      flash[:danger] = resource.errors[:base].first unless resource.errors[:base].empty?
      if resource.errors[:base].empty?
        flash[:danger] = t(:'ez_on_rails.not_destroyable', resource_obj: User.model_name.human)
      end
      render :edit
    end
  end

  # See description of set_title in ApplicationController.
  def set_title
    @title = t(:register)
  end
end
