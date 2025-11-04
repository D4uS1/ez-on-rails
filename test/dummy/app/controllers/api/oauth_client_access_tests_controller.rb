# frozen_string_literal: true

# Controller class for a OauthClientAccessTest resource.
class Api::OauthClientAccessTestsController < EzOnRails::Api::ResourceController
  include OauthClientAccessTestsHelper
  load_and_authorize_resource class: OauthClientAccessTest

  self.model_class = OauthClientAccessTest

  # Fixes that rails does not include active storage fields in the parameter wrapper
  wrap_parameters :oauth_client_access_test, include: OauthClientAccessTest.wrapped_parameter_names

end
