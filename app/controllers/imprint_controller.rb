# frozen_string_literal: true

# Controller class for the imprint of the page.
class ImprintController < EzOnRails::ApplicationController
  before_action :set_breadcrumb_imprint

  # GET Action for showing up the imprint.
  def index; end

  protected

  # Sets the breadcrumb of the contact form.
  def set_breadcrumb_imprint
    breadcrumb t(:imprint),
               controller: 'imprint',
               action: 'index'
  end

  # See description of set_title in ApplicationController.
  def set_title
    @title = t(:imprint)
  end
end
