# frozen_string_literal: true

# Controller class for showing up all files which were uploaded, but are not assigned to any
# Resource. This normally happens if some user did a direct upload and quit the form before
# submitting.
class EzOnRails::Admin::BroomCloset::UnattachedFilesController < EzOnRails::Admin::BroomCloset::BroomClosetController
  include EzOnRails::EzAjaxHelper

  before_action :breadcrumb_unattached_files

  # Constructor.
  def initialize
    super()
    @service = EzOnRails::Admin::BroomClosetService.new
  end

  # GET action to display all unattached files
  def index
    @subtitle = t(:'ez_on_rails.unattached_files_subtitle')

    # info for search form
    @queue_obj = EzOnRails::ActiveStorageRansackBlob.ransack params[:q]
    @obj_class = EzOnRails::ActiveStorageRansackBlob

    # resources
    @unattached_files = @service.unattached_files.ransack(params[:q]).result.paginate(
      page: params[:page],
      per_page: EzOnRails::ResourceController::MAX_INDEX_PAGE_ROWS
    )
  end

  # POST search action to filter overview.
  def search
    index
    render :index
  end

  # DELETE action to destroy all unattached files
  def destroy_all
    not_purged = 0

    # destroy all unattached files
    @service.unattached_files.each do |unattached_file|
      not_purged += 1 unless unattached_file.purge
    end

    # user feedback
    if not_purged.zero?
      flash[:success] = t(:'ez_on_rails.unattached_files_success')
    else
      flash[:alert] = t(:'ez_on_rails.unattached_files_failed', count: not_purged)
    end

    # redirect
    redirect_to action: 'index'
  end

  # DELETE action to destroy all selected unattached files
  def destroy_selections
    # Get selections and all resources
    selections = enhanced_table_selections(params).map { |selection| selection[:data][:id] }

    # destroy them
    purged = @service.destroy_unattached_files(selections)

    # user feedback
    if selections.length == purged
      flash[:success] = t(:'ez_on_rails.unattached_files_success')
    else
      flash[:alert] = t(:'ez_on_rails.unattached_files_failed', count: selections.length - purged)
    end

    # redirect
    render js: "window.location = '#{ez_on_rails_unattached_files_path}'"
  end

  protected

  # See description of set_title in ApplicationController.
  def set_title
    @title = t(:'ez_on_rails.broom_closet')
  end

  # Sets the breadcrumb to the nil_owners controller.
  def breadcrumb_unattached_files
    breadcrumb I18n.t(:'ez_on_rails.unattached_files'),
               controller: '/ez_on_rails/admin/broom_closet/unattached_files',
               action: 'index'
  end
end
