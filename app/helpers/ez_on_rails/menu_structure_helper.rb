# frozen_string_literal: true

# Model class defining the EzNav Navigation menu.
module EzOnRails::MenuStructureHelper
  # Needed by the EzNav generator to identify existing entries.
  module_function

  # Returns the menu structure of the application.
  # Information about the possible entries and structure can be read
  # in thr README file of ez_on_rails.
  def menu_structure
    {
      main_menus: [
          {
              controller: 'ez_on_rails/welcome',
              action: 'index',
              label: t(:welcome_title),
              invisible: true
          },
          {
              label: t(:'ez_on_rails.administration'),
              namespace: 'ez_on_rails/admin',
              sub_menus: [
                  {
                      controller: 'ez_on_rails/admin/dashboard',
                      action: 'index',
                      label: t(:'ez_on_rails.dashboard'),
                      invisible: false
                  },
                  {
                      controller: 'ez_on_rails/admin/user_management/dashboard',
                      action: 'index',
                      label: t(:'ez_on_rails.user_management'),
                      invisible: false
                  },
                  {
                      controller: 'ez_on_rails/admin/user_management/users',
                      action: 'index',
                      label: User.model_name.human(count: 2),
                      invisible: true
                  },
                  {
                      controller: 'ez_on_rails/admin/user_management/groups',
                      action: 'index',
                      label: EzOnRails::Group.model_name.human(count: 2),
                      invisible: true
                  },
                  {
                      controller: 'ez_on_rails/admin/user_management/user_group_assignments',
                      action: 'index',
                      label: EzOnRails::UserGroupAssignment.model_name.human(count: 2),
                      invisible: true
                  },
                  {
                      controller: 'ez_on_rails/admin/user_management/group_accesses',
                      action: 'index',
                      label: EzOnRails::GroupAccess.model_name.human(count: 2),
                      invisible: true
                  },
                  {
                      controller: 'ez_on_rails/admin/user_management/ownership_infos',
                      action: 'index',
                      label: EzOnRails::OwnershipInfo.model_name.human(count: 2),
                      invisible: true
                  },
                  {
                      controller: 'ez_on_rails/admin/broom_closet/dashboard',
                      action: 'index',
                      label: t(:broom_closet),
                      invisible: false
                  },
                  {
                      controller: 'ez_on_rails/admin/broom_closet/nil_owners',
                      action: 'index',
                      label: t(:'ez_on_rails.nil_owners'),
                      invisible: true
                  },
                  {
                      controller: 'ez_on_rails/admin/broom_closet/unattached_files',
                      action: 'index',
                      label: t(:'ez_on_rails.unattached_files'),
                      invisible: true
                  }
              ]
          }
      ]
    }
  end
end
