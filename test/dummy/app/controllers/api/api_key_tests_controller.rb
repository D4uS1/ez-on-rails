# frozen_string_literal: true

# Controller class for a ApiKeyTests resource.
class Api::ApiKeyTestsController < EzOnRails::Api::ResourceController
  include ::ApiKeyTestsHelper
  load_and_authorize_resource class: ApiKeyTest

  self.model_class = ApiKeyTest
end
