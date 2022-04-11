# frozen_string_literal: true

# Module to toggle parts of the layout to be shown or hidden.
# Every show_... method is used by the layout to determine wether the corresponding layout
# part is shown or not.
module EzOnRails::LayoutToggleHelper
  # Returns whether the privacy policy should be shown in the layout.
  def show_privacy_policy?
    true
  end

  # Returns whether the contact form should be shown in the layout.
  def show_contact_form?
    true
  end

  # Returns whether the language switcher should be shown in the layout.
  def show_locale_switch?
    true
  end
end
