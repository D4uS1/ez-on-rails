# frozen_string_literal: true

# Controller class for a  resource.
class ApiKeyTestsController < EzOnRails::ResourceController
  include ApiKeyTestsHelper

  load_and_authorize_resource class: ApiKeyTest

  before_action :breadcrumb_api_key_test
  self.model_class = ApiKeyTest

  protected

  # Sets the breadcrumb to the index action of the controllers resource.
  def breadcrumb_api_key_test
    breadcrumb ApiKeyTest.model_name.human(count: 2),
               controller: '/api_key_tests',
               action: 'index'
  end
end
