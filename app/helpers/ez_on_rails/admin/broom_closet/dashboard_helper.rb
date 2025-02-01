# frozen_string_literal: true

# Helper module for the dashboard of Admin::BroomCloset
module EzOnRails::Admin::BroomCloset::DashboardHelper
  # Needed by the EzDash Generator to identify existing tiles.

  module_function

  # Returns the dashboard information for the dashboard
  # in Admin::BroomCloset.
  def dash_info_admin_broom_closet
    [
      {
        label: EzOnRails::OwnershipInfo.model_name.human(count: 2),
        tiles: [
          {
            label: t(:'ez_on_rails.nil_owners'),
            background_color: '#FFE4C4',
            text_color: '#000000',
            text: t(:'ez_on_rails.nil_owners_description'),
            icon: 'user-slash',
            controller: 'ez_on_rails/admin/broom_closet/nil_owners',
            action: 'index'
          }
        ]
      },
      {
        label: t(:'ez_on_rails.files'),
        tiles: [
          {
            label: t(:'ez_on_rails.unattached_files'),
            background_color: '#FFB6C1',
            text_color: '#000000',
            text: t(:'ez_on_rails.unattached_files_description'),
            icon: 'file-excel',
            controller: 'ez_on_rails/admin/broom_closet/unattached_files',
            action: 'index'
          }
        ]
      }
    ]
  end
end
