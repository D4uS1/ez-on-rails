# frozen_string_literal: true

# Controller for Resource Controllers in the admin namespace.
# This controller uses a breadcrumb referencing to the admin dashboard.
# Hence every resource controller in the admin namespace should inherit
# from this controller.
class EzOnRails::Admin::AdminResourceController < EzOnRails::ResourceController
  before_action :breadcrumb_admin

  protected

  # Sets the breadcrumb to the admin dashboard.
  def breadcrumb_admin
    breadcrumb I18n.t(:'ez_on_rails.administration'),
               controller: '/ez_on_rails/admin/dashboard',
               action: 'index'
  end
end
