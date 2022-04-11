# frozen_string_literal: true

require 'will_paginate/array'

# Controller for brooms to clean up the application.
# Contains actions for e.g. destroying resourrces which are user owned, but does
# not reference to any user.
class EzOnRails::Admin::BroomCloset::NilOwnersController < EzOnRails::Admin::BroomCloset::BroomClosetController
  include EzOnRails::EzAjaxHelper

  before_action :breadcrumb_nil_owners

  # Constructor.
  def initialize
    super()
    @service = EzOnRails::Admin::BroomClosetService.new
  end

  # GET action to display all nil owned resources
  def index
    @subtitle = t(:'ez_on_rails.nil_owners_subtitle')

    # info for search form
    @queue_obj = EzOnRails::OwnershipInfo.ransack
    @obj_class = EzOnRails::OwnershipInfo

    # resources
    @nil_owners = @service.nil_owners.paginate(
      page: params[:page],
      per_page: EzOnRails::ResourceController::MAX_INDEX_PAGE_ROWS
    )

    # filter by search, if given
    search_params = q_params

    @nil_owners.select! { |nil_owner| nil_owner.id.to_s == search_params[:id_cont] } if search_params[:id_cont].present?

    return if search_params[:clazz_cont].blank?

    @nil_owners.select! { |nil_owner| nil_owner.class.to_s.include? search_params[:clazz_cont] }
  end

  # POST search action to filter overview.
  def search
    index
    render :index
  end

  # DELETE action to destroy all nil owned resources
  def destroy_all
    not_destroyed = 0

    # Remove all resources
    @service.nil_owners.each do |nil_owner|
      not_destroyed += 1 unless nil_owner.destroy
    end

    # user feedback
    if not_destroyed.zero?
      flash[:success] = t(:'ez_on_rails.nil_owners_success')
    else
      flash[:alert] = t(:'ez_on_rails.nil_owners_failed', count: not_destroyed)
    end

    # redirect
    redirect_to action: 'index'
  end

  # DELETE action to destroy all selected resources
  def destroy_selections
    # Get selections and all resources
    selections = enhanced_table_selections(params).pluck(:data)

    # destroy them
    destroyed = @service.destroy_nil_owners(selections)

    # user feedback
    if destroyed == selections.length
      flash[:success] = t(:'ez_on_rails.nil_owners_success')
    else
      flash[:alert] = t(:'ez_on_rails.nil_owners_failed', count: selections.length - destroyed)
    end

    # redirect
    redirect_to action: 'index'
  end

  protected

  # See description of set_title in ApplicationController.
  def set_title
    @title = t(:'ez_on_rails.broom_closet')
  end

  # Sets the breadcrumb to the nil_owners controller.
  def breadcrumb_nil_owners
    breadcrumb I18n.t(:'ez_on_rails.nil_owners'),
               controller: '/ez_on_rails/admin/broom_closet/nil_owners',
               action: 'index'
  end

  private

  # permits the search params and returns the permitted ones.
  def q_params
    return {} unless params['q']

    params.require(:q).permit(:id_cont, :clazz_cont)
  end
end
