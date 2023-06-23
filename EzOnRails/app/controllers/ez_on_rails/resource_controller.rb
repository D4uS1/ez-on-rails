# frozen_string_literal: true

# A base controller class for a controller managing some resource.
#
# Automaticly checks the access rights for the resource. The access
# right checks will be skipped for the index action.
#
# Contains default actions which can be overriden by the subclass.
# By default, the instance Variable for one single resource is @resource_obj the instance variable
# for multiple resources is @resource_obj.
# The default actions need the information which resource class is managed by this controller.
# This is done by setting self.model_class=ResourceClass .
class EzOnRails::ResourceController < EzOnRails::ApplicationController
  include EzOnRails::EzScaff::UrlHelper
  include EzOnRails::EzAjaxHelper

  before_action :set_resource_obj, only: %i[show edit update destroy]

  skip_authorize_resource only: :index

  # Constant for maximum Entries for index action per page
  MAX_INDEX_PAGE_ROWS = 20

  # Default index GET action.
  def index
    @subtitle = t(:'ez_on_rails.overview')

    # result objects
    @resource_objs = search_query.paginate page: params[:page], per_page: MAX_INDEX_PAGE_ROWS
  end

  # Default search POST | GET acton.
  def search
    index
    render :index
  end

  # Default show GET action.
  def show
    @subtitle = t(:'ez_on_rails.show')
  end

  # Default new GET action.
  def new
    @subtitle = t(:'ez_on_rails.new')

    @resource_obj = model_class.new
  end

  # Default edit GET action.
  def edit
    @subtitle = t(:'ez_on_rails.edit')
  end

  # Default create POST action.
  def create
    @resource_obj = model_class.new(resource_params)

    # set the resources user owner to the current user
    owner(@resource_obj)

    # try to save and give feedback
    if @resource_obj.save
      flash[:success] = t(:'ez_on_rails.create_success_message', resource_obj: model_class.model_name.human)
      redirect_to after_create_path
    else
      flash[:danger] = t(:'ez_on_rails.invalid_inputs_message')
      render :new, status: :unprocessable_entity
    end
  end

  # Default update PATCH/PUT action.
  def update
    # try to update and give feedback
    if @resource_obj.update(resource_params)
      flash[:success] = t(:'ez_on_rails.update_success_message', resource_obj: model_class.model_name.human)
      redirect_to after_update_path
    else
      flash[:danger] = @resource_obj.errors[:base].first unless @resource_obj.errors[:base].empty?
      flash[:danger] = t(:'ez_on_rails.invalid_inputs_message') if @resource_obj.errors[:base].empty?
      render :edit, status: :unprocessable_entity
    end
  end

  # Default destroy DELETE action.
  def destroy
    # try to destroy and give feedback
    if @resource_obj.destroy
      flash[:success] = t(:'ez_on_rails.destroy_success_message', resource_obj: model_class.model_name.human)
      redirect_to after_destroy_path
    else
      flash[:danger] = @resource_obj.errors[:base].first unless @resource_obj.errors[:base].empty?
      if @resource_obj.errors[:base].empty?
        flash[:danger] = t(:'ez_on_rails.not_destroyable', resource_obj: model_class.model_name.human)
      end
      redirect_back fallback_location: root_path
    end
  end

  # Default destroy_selections DELETE action.
  def destroy_selections
    enhanced_table_selections_action do |selected_ids, _selected_data|
      resources = model_class.where id: selected_ids

      # Destroy them
      not_destroyable = []
      resources.each do |resource|
        # security check if anyone passes an unallowed id
        next unless access_to_destroy_resource? resource

        not_destroyable.push resource.id unless resource.destroy
      end

      # Refresh page and notice user
      if not_destroyable.empty?
        flash[:success] = t(:'ez_on_rails.destroy_success_message_multiple',
                            resource_obj: model_class.model_name.human(count: 2))
      else
        flash[:danger] = t(:'ez_on_rails.not_destroyable_multiple',
                           count: not_destroyable.length,
                           resource_obj: model_class.model_name.human(count: 2))
      end
    end
  end

  # Class Variable setter method for the resource class and permit_render_info
  # Resource class Needs to be defined by the subclasses.
  class << self
    attr_accessor :model_class
  end

  # Wrapper class to class instance variable for model_class to keep the code readable.
  def model_class
    self.class.model_class
  end

  private

  # Returns the query to search for resources by the given search_params.
  # Also assigns the following instance variables for various actions.
  #   @obj_class is the current model_class
  #   @search_params are the search_params the user submitted
  #   @queue_obj is the initial ransack queue object
  #   @objects_count are the results count for the current search
  def search_query
    @obj_class = model_class
    @search_params = search_params

    # queue object and object class reference for search form
    @queue_obj = model_class.ransack(@search_params)

    # add default sorting, because default seems to be updated_at asc
    @queue_obj.sorts = "#{default_order.keys.first} #{default_order.values.first}" if @queue_obj.sorts.empty?

    # construct query with access restrictions
    # NASTY HACK: Only fetch the different ids, to simulate a distinct, this is needed
    # because if the model contains json fields distinct is not possible on postgres databases.
    # Even if you would use jsonb, sorting by associations would not be possible with distinct.
    resource_objs_query = @queue_obj.result.accessible_by(
      current_ability,
      :show
    )

    # results count (without pagination)
    @objects_count = resource_objs_query.count

    resource_objs_query
  end

  # Finds the resource by the id param and stores it to the resource instance variable.
  def set_resource_obj
    @resource_obj = model_class.find(
      params[:id] ||
      params["#{resource_symbol}_id".to_sym] ||
      params["#{non_namespaced_resource_symbol}_id".to_sym]
    )
  end

  # Only allow a trusted parameter "white list" through.
  def resource_params
    if params[resource_symbol]
      return params.require(resource_symbol).permit(default_permit_params(send(permit_render_info)))
    end

    params.require(non_namespaced_resource_symbol).permit(default_permit_params(send(permit_render_info)))
  end

  def search_params
    params[:q]&.permit!
  end

  # returns the symbol of this resource class.
  def resource_symbol
    model_class.to_s.underscore.tr('/', '_').to_sym
  end

  # Returns the symbol of the resource without namespace.
  def non_namespaced_resource_symbol
    model_class.to_s.split('::').last.underscore.to_sym
  end

  protected

  # Returns the path the user is redirected to after a resource has been successfully created.
  def after_create_path
    @resource_obj
  end

  # Returns the path the user is redirected to after a resource has been successfully updated.
  def after_update_path
    @resource_obj
  end

  # Returns the path the user is redirected to after a resource has been successfully destroyed.
  def after_destroy_path
    search_url_for({ action: :index }, search_params)
  end

  # Returns name of the render_info method used for permitting parameters.
  def permit_render_info
    # first try to find namespaced render_info
    return "render_info_#{resource_symbol}" if respond_to?("render_info_#{resource_symbol}")

    # try with non namespaced render_info
    "render_info_#{non_namespaced_resource_symbol}"
  end

  # Sets the title for the heading partial.
  # Exceuted before every action. Can be overriden by subclasses.
  def set_title
    @title = model_class.model_name.human
  end

  # Sets the owner of the given resource to the current user.
  def owner(resource)
    resource.owner = current_user if resource.respond_to?(:owner) && resource.owner.nil?
  end

  # The default order list actions order its results by.
  # expects a hash having the key to order by and the order direction (:asc, :desc) as value.
  def default_order
    { id: :asc }
  end
end
