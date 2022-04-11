# frozen_string_literal: true

# Controller class for the admin dashboard.
class EzOnRails::Admin::DashboardController < EzOnRails::Admin::AdminController
  # Action for showing the dashboard.
  def index
    @subtitle = t(:'ez_on_rails.dashboard')
  end

  protected

  # See description of set_title in ApplicationController.
  def set_title
    @title = t(:'ez_on_rails.administration')
  end
end
