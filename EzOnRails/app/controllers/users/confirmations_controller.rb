# frozen_string_literal: true

# Controller for confirmations managed by devise.
class Users::ConfirmationsController < Devise::ConfirmationsController
  # TODO: delete after devise update for Rails 7
  include DeviseTurboConcern

  respond_to :json

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    @subtitle = t(:confirmation)
    super
  end

  # GET /resource/confirmation/new
  def new
    @subtitle = t(:resend_confirmation_email)
    super
  end

  protected

  # See description of set_title in ApplicationController.
  def set_title
    @title = t(:confirmation_email)
  end
end
