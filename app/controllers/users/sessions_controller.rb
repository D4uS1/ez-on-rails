# frozen_string_literal: true

# Controller for sessions managed by devise.
class Users::SessionsController < Devise::SessionsController
  respond_to :json

  protected

  # See description of set_title in ApplicationController.
  def set_title
    @title = t(:log_in)
  end
end
