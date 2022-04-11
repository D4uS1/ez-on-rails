# frozen_string_literal: true

# Controller for the Admin/UserManagement dashboard.
class EzOnRails::Admin::UserManagement::DashboardController < EzOnRails::Admin::UserManagement::UserManagementController
  # Action for showing the dashboard.
  def index
    @subtitle = t(:'ez_on_rails.dashboard')
  end

  protected

  # See description of set_title in ApplicationController.
  def set_title
    @title = t(:'ez_on_rails.user_management')
  end
end
