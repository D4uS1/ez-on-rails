# frozen_string_literal: true

# Controller class for the privacy policy of the page.
class PrivacyPolicyController < EzOnRails::ApplicationController
  include EzOnRails::LayoutToggleHelper

  before_action :set_breadcrumb_privacy_policy
  before_action :redirect_on_disable

  # GET Action for showing up the privacy policy.
  def index; end

  protected

  # Sets the breadcrumb of the contact form.
  def set_breadcrumb_privacy_policy
    breadcrumb t(:privacy_policy),
               controller: 'privacy_policy',
               action: 'index'
  end

  # See description of set_title in ApplicationController.
  def set_title
    @title = t(:privacy_policy)
  end

  # Called in before_action to redirect to root_path if the contact form
  # is disabled via layout_toggle_helper.
  def redirect_on_disable
    redirect_to root_path unless show_privacy_policy?
  end
end
