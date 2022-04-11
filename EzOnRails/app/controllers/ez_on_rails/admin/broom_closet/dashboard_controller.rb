# frozen_string_literal: true

# Controller class for the admin dashboard.
class EzOnRails::Admin::BroomCloset::DashboardController < EzOnRails::Admin::AdminController
  # Index action renders the dashboard
  def index
    @subtitle = t(:cleanup_actions)
  end

  protected

  # See description of set_title in ApplicationController.
  def set_title
    @title = t(:'ez_on_rails.broom_closet')
  end
end
