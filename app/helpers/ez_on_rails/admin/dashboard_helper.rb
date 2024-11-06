# frozen_string_literal: true

# Helper module for the dashboard of Admin.
module EzOnRails::Admin::DashboardHelper
  # Needed by the EzDash Generator to identify existing tiles.

  module_function

  # Returns the dashboard information for the dashboard
  # in Admin.
  def dash_info_admin
    [
      {
        tiles: [
          {
            label: t(:'ez_on_rails.user_management'),
            background_color: '#FFA07A',
            text_color: '#000000',
            text: t(:'ez_on_rails.user_management_description'),
            icon: 'users',
            controller: 'ez_on_rails/admin/user_management/dashboard',
            action: 'index'
          },
          {
            label: t(:'ez_on_rails.broom_closet'),
            background_color: '#4682B4',
            text_color: '#FFFFFF',
            text: t(:'ez_on_rails.broom_closet_description'),
            icon: 'broom',
            controller: 'ez_on_rails/admin/broom_closet/dashboard',
            action: 'index'
          }
        ]
      }
    ]
  end
end
