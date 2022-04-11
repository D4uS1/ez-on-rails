# frozen_string_literal: true

# Helper module for ContactForm form.
module ContactFormHelper
  # Returns the render information for the ContactForm form.
  def render_info_contact_form
    {
      name: {
        label: ContactForm.human_attribute_name(:name),
        type: :string
      },
      email: {
        label: ContactForm.human_attribute_name(:email),
        type: :string
      },
      subject: {
        label: ContactForm.human_attribute_name(:subject),
        type: :string
      },
      message: {
        label: ContactForm.human_attribute_name(:message),
        type: :text
      },
      privacy_policy_accepted: {
        label: proc { sanitize(t(:i_accept_privacy_policy, privacy_policy_url: privacy_policy_url)) },
        type: :boolean
      }
    }
  end
end
