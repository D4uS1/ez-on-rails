# frozen_string_literal: true

# Helper Module for users.
module UsersHelper
  # Returns the render information for an user confirmations form
  # for rendering using the EzOnRails Partials.
  def render_info_users_confirmations
    {
      email: {
        label: User.human_attribute_name(:email),
        html_options: {
          autofocus: true,
          autocomplete: 'email'
        }
      }
    }
  end

  # Returns the render information for an user passwords form
  # for rendering using the EzOnRails Partials.
  def render_info_users_passwords
    {
      reset_password_token: {
        type: :hidden,
        hide: [:new]
      },
      password: {
        label: t(:new_password),
        type: :password,
        hide: [:new],
        help: proc do |form|
          if @minimum_password_length
            render_attribute_help(form,
                                  help: t(:minimum_password_length, minimum_password_length: @minimum_password_length))
          end
        end,
        html_options: {
          autofocus: true,
          autocomplete: 'new-password'
        }
      },
      email: {
        label: User.human_attribute_name(:email),
        hide: [:edit],
        html_options: {
          autofocus: true,
          autocomplete: 'email'
        }
      }
    }
  end

  # Returns the render information for an user registrations form
  # for rendering using the EzOnRails Partials.
  def render_info_users_registrations
    {
      username: {
        label: User.human_attribute_name(:username),
        html_options: {
          autofocus: true
        }
      },
      email: {
        label: User.human_attribute_name(:email),
        help: proc do |form|
          if devise_mapping.confirmable? && resource.pending_reconfirmation?
            render_attribute_help(form,
                                  help: t(:confirmation_pending, unconfirmed_email: resource.unconfirmed_email))
          end
        end,
        html_options: {
          autocomplete: 'email'
        }
      },
      avatar: {
        label: User.human_attribute_name(:avatar),
        type: :image,
        hide: [:new]
      },
      password: {
        label: User.human_attribute_name(:password),
        type: :password,
        help: proc do |form|
          if @minimum_password_length
            render_attribute_help(form,
                                  help: t(:minimum_password_length, minimum_password_length: @minimum_password_length))
          end
        end,
        html_options: {
          autocomplete: 'new-password'
        }
      },
      password_confirmation: {
        label: t(:confirm_password),
        type: :password,
        html_options: {
          autocomplete: 'off'
        }
      },
      current_password: {
        label: t(:current_password),
        type: :password,
        hide: [:new],
        help: t(:current_password_needed),
        html_options: {
          autocomplete: 'current-password'
        }
      },
      privacy_policy_accepted: {
        label: proc { sanitize(t(:i_accept_privacy_policy, privacy_policy_url: privacy_policy_url)) }
      }
    }
  end

  # Returns the render information for an user confirmations form
  # for rendering using the EzOnRails Partials.
  def render_info_users_sessions
    {
      email: {
        label: User.human_attribute_name(:email),
        html_options: {
          autocomplete: 'email',
          autofocus: true
        }
      },
      password: {
        label: User.human_attribute_name(:password),
        type: :password,
        html_options: {
          autocomplete: 'current-password'
        }
      },
      remember_me: {
        label: t(:stay_logged_in),
        type: :boolean
      }
    }
  end

  # Returns the render information for an user registrations form
  # for rendering using the EzOnRails Partials.
  def render_info_omniauth_sign_up
    {
      username: {
        type: :hidden
      },
      email: {
        type: :hidden
      },
      provider: {
        type: :hidden
      },
      uid: {
        type: :hidden
      },
      confirmed_at: {
        type: :hidden
      },
      privacy_policy_accepted: {
        label: proc { sanitize(t(:i_accept_privacy_policy, privacy_policy_url: privacy_policy_url)) }
      }
    }
  end
end
