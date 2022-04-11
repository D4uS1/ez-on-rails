# frozen_string_literal: true

# A base controller class for a api controller managing some resource.
#
# Contains default actions which can be overriden by the subclass.
# By default, the instance Variable for one single resource is @resource_obj the instance variable
# for multiple resources is @resource_obj.
# The default actions need the information which resource class is managed by this controller.
# This is done by setting self.model_class=ResourceClass .
class EzOnRails::Api::ResourceController < EzOnRails::Api::BaseController
  skip_authorize_resource only: :index
  before_action :set_resource_obj, only: %i[show update destroy]

  # needed because cancancan tries to access the resources with "find"
  rescue_from ActiveRecord::RecordNotFound do
    handle_api_error EzOnRails::ResourceNotFoundError.new(message: 'resource not found')
  end

  # GET show action to get an existing single resource instance.
  def show; end

  # GET index action to get all existing resource instances.
  def index
    @resource_objs = model_class.accessible_by(
      current_ability,
      :show
    )
  end

  # GET search action to search for existing resourcey by matching attributes.
  def search
    search_filter = EzOnRails::SearchFilterParser.parse(search_filter_params)

    @resource_objs = model_class.search_for(search_filter).accessible_by(
      current_ability,
      :show
    )

    # append order query
    order = params[:order] || 'id'
    order_direction = params[:order_direction] || 'asc'
    @resource_objs = @resource_objs.order("#{order} #{order_direction}")

    # append pagination, if given
    return unless params[:page] && params[:page_size]

    page_size = params[:page_size].to_i
    offset = params[:page].to_i * page_size
    @pages_count = (@resource_objs.count / page_size.to_f).ceil.to_i
    @resource_objs = @resource_objs.limit(page_size).offset(offset)
  end

  # POST create action to create a new resource instance.
  def create
    @resource_obj = model_class.new(resource_params)
    owner(@resource_obj)

    raise EzOnRails::ValidationFailedError, @resource_obj unless @resource_obj.save

    render status: :created
  end

  # PUT update action to update an existing resource instance.
  def update
    render status: :not_found if @resource_obj.nil?

    raise EzOnRails::ValidationFailedError, @resource_obj unless @resource_obj.update(resource_params)

    render status: :ok
  end

  # DELETE destroy action.
  def destroy
    render status: :not_found if @resource_obj.nil?

    raise EzOnRails::ValidationFailedError, @resource_obj unless @resource_obj.destroy

    render json: {}, status: :no_content
  end

  # Class Variable setter method for the resource class, resource symbol and pluralized resource symbol.
  # Resource class Needs to be defined by the subclasses.
  class << self
    attr_accessor :model_class
  end

  # Wrapper for class to class instance variable for model_class to keep the code readable.
  def model_class
    self.class.model_class
  end

  # Wrapper for class to class instance variable for permitted_params to keep the code readable.
  def permitted_params
    self.class.permitted_params
  end

  private

  # Finds the resource by the id param and stores it to the resource instance variable.
  # If the resource was not found, http status code 404 will be returned.
  def set_resource_obj
    @resource_obj = model_class.find(params[:id])
  end

  # Returns the symbol of the resource.
  # If without_namespace is true, the symbol will be returned without namespaces.
  # This is necessary because we do not want api calls to need to pass parameters including the namespaces.
  def resource_symbol(without_namespace: false)
    return model_class.to_s.underscore.tr('/', '_').to_sym unless without_namespace

    model_class.to_s.split('::').last.underscore.tr('/', '_').to_sym
  end

  protected

  # Only allow a trusted parameter "white list" through.
  def resource_params
    # with namespaces
    resource_name_sym = resource_symbol
    if params[resource_name_sym]
      params.require(resource_name_sym).permit(default_permit_params(send("render_info_#{resource_name_sym}")))
    end

    # without namespaces
    resource_name_sym = resource_symbol(without_namespace: true)
    params.require(resource_name_sym).permit(default_permit_params(send("render_info_#{resource_name_sym}")))
  end

  # Returns the parameters to filter records for the search action.
  def search_filter_params
    params[:filter]
  end

  # Sets the owner of the given resource to the current user.
  def owner(resource)
    resource.owner = current_user
  end

  # overwrites the ability class name of cancancan to the namespaced
  # engines ability class.
  def current_ability
    @current_ability ||= EzOnRails::Ability.new(current_user)
  end
end
