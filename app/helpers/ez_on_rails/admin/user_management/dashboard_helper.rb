# frozen_string_literal: true

# Helper module for the dashboard of Admin::UserManagement
module EzOnRails::Admin::UserManagement::DashboardHelper
  # Needed by the EzDash Generator to identify existing tiles.

  module_function

  # Returns the dashboard information for the dashboard
  # in Admin::UserManagement.
  def dash_info_admin_user_management
    [
      {
        label: t(:'ez_on_rails.users_and_groups'),
        tiles: [
          {
            label: User.model_name.human(count: 2),
            background_color: '#FF7F50',
            text_color: '#000000',
            text: t(:'ez_on_rails.users_description'),
            icon: 'user',
            controller: 'ez_on_rails/admin/user_management/users',
            action: 'index'
          },
          {
            label: EzOnRails::Group.model_name.human(count: 2),
            background_color: '#CD5C5C',
            text_color: '#FFFFFF',
            text: t(:'ez_on_rails.groups_description'),
            icon: 'users',
            controller: 'ez_on_rails/admin/user_management/groups',
            action: 'index'
          }
        ]
      },
      {
        label: t(:'ez_on_rails.permissions'),
        tiles: [
          {
            label: EzOnRails::UserGroupAssignment.model_name.human(count: 2),
            background_color: '#00008B',
            text_color: '#FFFFFF',
            icon: 'user-plus',
            text: t(:'ez_on_rails.user_group_assignments_description'),
            controller: 'ez_on_rails/admin/user_management/user_group_assignments',
            action: 'index'
          },
          {
            label: EzOnRails::GroupAccess.model_name.human(count: 2),
            background_color: '#6495ED',
            text_color: '#FFFFFF',
            icon: 'lock',
            text: t(:'ez_on_rails.group_accesses_description'),
            controller: 'ez_on_rails/admin/user_management/group_accesses',
            action: 'index'
          },
          {
            label: EzOnRails::OwnershipInfo.model_name.human(count: 2),
            background_color: '#1E90FF',
            text_color: '#FFFFFF',
            icon: 'bookmark',
            text: t(:'ez_on_rails.ownership_infos_description'),
            controller: 'ez_on_rails/admin/user_management/ownership_infos',
            action: 'index'
          }
        ]
      },
      {
        label: t(:'ez_on_rails.ownership_accesses'),
        tiles: [
          {
            label: EzOnRails::ResourceReadAccess.model_name.human(count: 2),
            background_color: '#008B8B',
            text_color: '#FFFFFF',
            text: t(:'ez_on_rails.resource_read_accesses_description'),
            icon: 'book',
            controller: 'ez_on_rails/admin/user_management/resource_read_accesses',
            action: 'index'
          },
          {
            label: EzOnRails::ResourceWriteAccess.model_name.human(count: 2),
            background_color: '#FFD700',
            text_color: '#000000',
            text: t(:'ez_on_rails.resource_write_accesses_description'),
            icon: 'pen',
            controller: 'ez_on_rails/admin/user_management/resource_write_accesses',
            action: 'index'
          },
          {
            label: EzOnRails::ResourceDestroyAccess.model_name.human(count: 2),
            background_color: '#8B0000',
            text_color: '#FFFFFF',
            text: t(:'ez_on_rails.resource_destroy_accesses_description'),
            icon: 'trash',
            controller: 'ez_on_rails/admin/user_management/resource_destroy_accesses',
            action: 'index'
          }
        ]
      }
    ]
  end
end
