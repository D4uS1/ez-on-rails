# frozen_string_literal: true

# Controller class for a  resource.
class OauthClientAccessTestsController < EzOnRails::ResourceController
  include OauthClientAccessTestsHelper

  load_and_authorize_resource class: OauthClientAccessTest

  before_action :breadcrumb_oauth_client_access_test
  self.model_class = OauthClientAccessTest

  protected

  # Sets the breadcrumb to the index action of the controllers resource.
  def breadcrumb_oauth_client_access_test
    breadcrumb OauthClientAccessTest.model_name.human(count: 2),
               controller: '/oauth_client_access_tests',
               action: 'index'
  end
end
