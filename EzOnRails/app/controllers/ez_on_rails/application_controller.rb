# frozen_string_literal: true

# Base Controller class of EzOnRails Engine.
class EzOnRails::ApplicationController < ApplicationController
  include ActionView::Helpers::TranslationHelper
  include EzOnRails::UserAccessHelper
  include ActionView::Context # needed for some reason, because _seach_form throws missing output_buffer

  layout 'ez_on_rails/layouts/application'

  protect_from_forgery with: :exception

  before_action :set_locale
  before_action :set_title
  before_action :breadcrumb_root
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_access_to_current_page

  skip_before_action :verify_authenticity_token, if: -> { request.format.json? }

  # Redirect to access denied page, if user does not have access to this resource.
  # If the user is not signed in, he will be asked to sign in.
  rescue_from CanCan::AccessDenied do |_exception|
    next access_denied if user_signed_in?

    # Request login
    authenticate_user!
  end

  rescue_from EzOnRails::Error, with: proc { |error| handle_error(error) }

  # Returns true if the current request is a json request.
  def json_request?
    request.format.json?
  end

  # Returns true if the current request is a html request.
  def html_request?
    request.format.html?
  end

  # Skips the current request and returns status code 406 for not acceptable
  # request type. This is for instance called by a filter that checks wether
  # the request was send in json or not.
  def invalid_request_type
    raise EzOnRails::InvalidRequestTypeError
  end

  protected

  # Sets the breadcrumb to the root page. Executed before every action.
  def breadcrumb_root
    breadcrumb I18n.t(:welcome_title), :root_path
  end

  # Needed by devise.
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username email password privacy_policy_accepted])
    devise_parameter_sanitizer.permit(
      :omniauth_sign_up,
      keys: %i[username email password privacy_policy_accepted uid provider confirmed_at redirect_route]
    )
    devise_parameter_sanitizer.permit(:account_update, keys: %i[username email avatar password privacy_policy_accepted])
  end

  # Sets the locale of the request. If no locale is specified in the params, the
  # default locale will be set.
  def set_locale
    I18n.locale = current_locale
  end

  # Returns the current locale. If no locale is specified in the params, the default
  # locale will be returned.
  def current_locale
    params[:locale] || I18n.default_locale
  end

  # Needed beecause url_for would not set the locale property by default, if this
  # method was not defined.
  def default_url_options
    { locale: I18n.locale }
  end

  # Can be overriden by the subclasses to set the title for the heading partial.
  # This method is executed before every action.
  def set_title
    @title = ''
  end

  # Returns the default permitted parameters defined by
  # the given render_info hash. This hash is returned by any helper created
  # by ez_on_rails:ezscaff.
  # it will return an array of symbols, containing the keys of the attributes of the model,
  # combined with an array of symbols containing the keys folllowed by _id.
  # the id version is necessary, because reference types need the id values from forms.
  def default_permit_params(render_info)
    result = render_info_permit_params(render_info)

    # search for nested params
    render_info.each do |attr_key, attr_render_info|
      next if attr_render_info[:type] != :nested_form

      # if :data it is a hash it is meant to be some render info
      if attr_render_info[:data].is_a?(Hash)
        nested_permit_params = default_permit_params(attr_render_info[:data][:render_info])

        # otherwise it is meant to be some render_info method
        # To not to get stack overflow in case of it is some self referencing nested form
        # we will have to do it without calling default_permit_params
      else
        render_info_nested = send(attr_render_info[:data][:render_info])
        nested_permit_params = render_info_permit_params(render_info_nested)
      end

      # add id to identify existing nested attributes in update actions
      nested_permit_params += %i[id _destroy]

      result.push("#{attr_key}_attributes": nested_permit_params)
    end

    result
  end

  # returns the default permitted parameters by its render_info hash.
  def render_info_permit_params(render_info)
    render_info.keys +
      # needed for :attachments
      render_info.keys.map { |key| { key.to_s.to_sym => (render_info[key][:type] == :json ? {} : []) } } +
      # needed for single references
      render_info.keys.map { |key| :"#{key}_id" } +
      # needed for single polymorphic references
      render_info.keys.map { |key| :"#{key}_type" } +
      # needed for has_many references
      render_info.keys.map { |key| { "#{key.to_s.singularize}_ids": [] } }
  end

  # overwrites the ability class name of cancancan to the namespaced
  # engines ability class.
  def current_ability
    @current_ability ||= EzOnRails::Ability.new(current_user)
  end

  # Handles the given raised api error.
  # Renders the error json view file having the http status given by the error.
  def handle_error(error)
    return render 'ez_on_rails/api/error', locals: { error: }, status: error.http_status if json_request?

    case error.http_status
    when :unauthorized
      render 'ez_on_rails/errors/401', status: error.http_status
    when :forbidden
      render 'ez_on_rails/errors/403', status: error.http_status
    when :not_found
      render 'ez_on_rails/errors/404', status: error.http_status
    when :internal_server_error
      render 'ez_on_rails/errors/500', status: error.http_status
    else
      render 'ez_on_rails/errors/some_error', status: error.http_status
    end
  end
end
