# frozen_string_literal: true

# Controller for unlocks managed by devise.
class Users::UnlocksController < Devise::UnlocksController
  respond_to :json

  # GET /resource/unlock/new
  def new
    @subtitle = t(:'ez_on_rails.new')
    super
  end

  # GET /resource/unlock?unlock_token=abcdef
  def show
    @subtitle = t(:'ez_on_rails.show')
    super
  end

  protected

  # See description of set_title in ApplicationController.
  def set_title
    @title = t(:unlocks)
  end
end
