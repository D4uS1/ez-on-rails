# frozen_string_literal: true

# Controller class for a  resource.
class ResourceGroupAccessTestsController < EzOnRails::ResourceController
  include ResourceGroupAccessTestsHelper

  load_and_authorize_resource class: ResourceGroupAccessTest

  before_action :breadcrumb_resource_group_access_test
  self.model_class = ResourceGroupAccessTest

  protected

  # Sets the breadcrumb to the index action of the controllers resource.
  def breadcrumb_resource_group_access_test
    breadcrumb ResourceGroupAccessTest.model_name.human(count: 2),
               controller: '/resource_group_access_tests',
               action: 'index'
  end
end
