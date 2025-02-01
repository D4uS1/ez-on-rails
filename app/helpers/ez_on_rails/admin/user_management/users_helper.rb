# frozen_string_literal: true

# Helper module for the user resource.
module EzOnRails::Admin::UserManagement::UsersHelper
  # Returns the render information for the User resource.
  def render_info_user
    {
      username: {
        label: User.human_attribute_name(:username)
      },
      email: {
        label: User.human_attribute_name(:email)
      },
      unconfirmed_email: {
        label: User.human_attribute_name(:unconfirmed_email),
        hide: %i[index edit new]
      },
      avatar: {
        label: User.human_attribute_name(:avatar),
        hide: [:index],
        type: :image
      },
      password: {
        label: User.human_attribute_name(:password),
        type: :password,
        hide: %i[index edit show search]
      },
      confirmed_at: {
        label: User.human_attribute_name(:confirmed_at)
      },
      privacy_policy_accepted: {
        label: User.human_attribute_name(:privacy_policy_accepted)
      },
      groups: {
        label: User.human_attribute_name(:groups),
        label_method: :name,
        no_sort: true,
        hide: [:new]
      }
    }
  end

  # Returns the render information for the User password reset
  def render_info_password_reset
    {
      password: {
        label: User.human_attribute_name(:password),
        type: :password
      }
    }
  end
end
