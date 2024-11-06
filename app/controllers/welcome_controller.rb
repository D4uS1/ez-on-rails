# frozen_string_literal: true

# Controller for the welcome page.
class WelcomeController < EzOnRails::ApplicationController
  # Action for showing the welcome page.
  def index
    @subtitle = t(:welcome_subtitle)
  end

  protected

  # See description of set_title in ApplicationController class.
  def set_title
    @title = t(:welcome_title)
  end
end
