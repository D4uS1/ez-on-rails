# frozen_string_literal: true

# Controller for Non-Resource Controllers in the admin/user_management namespace.
# This controller uses a breadcrumb referencing to the admin/user_management dashboard.
# Hence every non-resource controller in the admin/user_management namespace should inherit
# from this controller.
class EzOnRails::Admin::BroomCloset::BroomClosetController < EzOnRails::Admin::AdminController
  before_action :breadcrumb_broom_closet

  protected

  # Sets the breadcrumb to the broom_closet dashboard.
  def breadcrumb_broom_closet
    breadcrumb I18n.t(:'ez_on_rails.broom_closet'),
               controller: '/ez_on_rails/admin/broom_closet/dashboard',
               action: 'index'
  end
end
