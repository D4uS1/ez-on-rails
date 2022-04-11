# frozen_string_literal: true

# Controller class for a  resource.
class SharableResourcesController < EzOnRails::ResourceController
  include SharableResourcesHelper

  load_and_authorize_resource class: SharableResource

  before_action :breadcrumb_sharable_resource
  self.model_class = SharableResource

  protected

  # Sets the breadcrumb to the index action of the controllers resource.
  def breadcrumb_sharable_resource
    breadcrumb SharableResource.model_name.human(count: 2),
               controller: '/sharable_resources',
               action: 'index'
  end
end
