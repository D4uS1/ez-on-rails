# frozen_string_literal: true

# Controller class for a BearerTokenAccessTest resource.
class Api::BearerTokenAccessTestsController < EzOnRails::Api::ResourceController
  include BearerTokenAccessTestsHelper
  load_and_authorize_resource class: BearerTokenAccessTest

  self.model_class = BearerTokenAccessTest

  # Fixes that rails does not include active storage fields in the parameter wrapper
  wrap_parameters :bearer_token_access_test, include: BearerTokenAccessTest.wrapped_parameter_names

end
