# frozen_string_literal: true

# Controller class for a  resource.
class BearerTokenAccessTestsController < EzOnRails::ResourceController
  include BearerTokenAccessTestsHelper

  load_and_authorize_resource class: BearerTokenAccessTest

  before_action :breadcrumb_bearer_token_access_test
  self.model_class = BearerTokenAccessTest

  protected

  # Sets the breadcrumb to the index action of the controllers resource.
  def breadcrumb_bearer_token_access_test
    breadcrumb BearerTokenAccessTest.model_name.human(count: 2),
               controller: '/bearer_token_access_tests',
               action: 'index'
  end
end
