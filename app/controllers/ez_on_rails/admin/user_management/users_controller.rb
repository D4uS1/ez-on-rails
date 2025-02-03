# frozen_string_literal: true

# Controller for a user resource.
class EzOnRails::Admin::UserManagement::UsersController <
    EzOnRails::Admin::UserManagement::UserManagementResourceController
  include EzOnRails::Admin::UserManagement::UsersHelper

  before_action :skip_email_reconfirmation, only: [:update]

  load_and_authorize_resource class: User

  self.model_class = User
  before_action :breadcrumb_users

  # GET /admin/user_management/users/:id/password_reset
  def password_reset
    set_resource_obj

    @subtitle = t(:reset_password)
  end

  # PATCH/PUT /admin/user_management/users/:id/password_reset
  def update_password
    set_resource_obj

    if @resource_obj.update(password_reset_params)
      flash[:success] = t(:reset_password_success)
      redirect_to ez_on_rails_user_path(@resource_obj)
    else
      render :password_reset
    end
  end

  protected

  # Called before update to skip the need for reconfirmation on update
  # via the user management.
  def skip_email_reconfirmation
    @resource_obj&.skip_reconfirmation!
  end

  # See after_create_path of parent class.
  def after_create_path
    ez_on_rails_user_path(@resource_obj)
  end

  # See after_update_path of parent class.
  def after_update_path
    ez_on_rails_user_path(@resource_obj)
  end

  # Sets the breadcrumb to the index page of this controllers resource.
  def breadcrumb_users
    breadcrumb self.class.model_class.model_name.human(count: 2),
               controller: '/ez_on_rails/admin/user_management/users',
               action: 'index'
  end

  private

  # Only allow a trusted parameter "white list" through.
  def password_reset_params
    params.expect(user: default_permit_params(render_info_password_reset))
  end
end
