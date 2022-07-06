# frozen_string_literal: true

# Helper module for the EzOnRails::Group resource.
module EzOnRails::Admin::UserManagement::GroupsHelper
  # Returns the render information for the EzOnRails::Group resource.
  def render_info_group
    {
      name: {
        label: EzOnRails::Group.human_attribute_name(:name)
      },
      user: {
        label: EzOnRails::Group.human_attribute_name(:user),
        label_method: :email
      },
      resource_group: {
        label: EzOnRails::Group.human_attribute_name(:resource_group),
      },
      resource_read: {
        label: EzOnRails::Group.human_attribute_name(:resource_read),
      },
      resource_write: {
        label: EzOnRails::Group.human_attribute_name(:resource_write),
      },
      resource_destroy: {
        label: EzOnRails::Group.human_attribute_name(:resource_destroy),
      },
      users: {
        label: EzOnRails::Group.human_attribute_name(:users),
        label_method: :email,
        hide: [:new],
        no_sort: true
      }
    }
  end
end
