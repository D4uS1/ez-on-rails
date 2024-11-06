# frozen_string_literal: true

# Controller class for a  resource.
class PropertiesTestsController < EzOnRails::ResourceController
  include PropertiesTestsHelper

  load_and_authorize_resource class: PropertiesTest

  before_action :breadcrumb_properties_test
  self.model_class = PropertiesTest

  protected

  # Sets the breadcrumb to the index action of the controllers resource.
  def breadcrumb_properties_test
    breadcrumb PropertiesTest.model_name.human(count: 2),
               controller: '/properties_tests',
               action: 'index'
  end
end
