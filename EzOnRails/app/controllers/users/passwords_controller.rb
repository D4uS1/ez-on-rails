# frozen_string_literal: true

# Controller for passwords managed by devise.
class Users::PasswordsController < Devise::PasswordsController
  respond_to :json

  # GET /users/password/new
  def new
    @subtitle = t(:request_password_change)
    super
  end

  # GET /users/password/edit?reset_password_token=abcdef
  def edit
    @subtitle = t(:change_password)
    super
  end

  protected

  # See description of set_title in ApplicationController.
  def set_title
    @title = t(:forgott_password)
  end
end
