# frozen_string_literal: true

# Controller class for a ApiKeyTest resource.
class Api::ApiKeyTestsController < EzOnRails::Api::ResourceController
  include ApiKeyTestsHelper
  load_and_authorize_resource class: ApiKeyTest

  self.model_class = ApiKeyTest

  # Fixes that rails does not include active storage fields in the parameter wrapper
  wrap_parameters :api_key_test, include: ApiKeyTest.wrapped_parameter_names

end
