# frozen_string_literal: true

# Controller class for a BearerTokenAccessTest resource.
class Api::BearerTokenAccessTestsController < EzOnRails::Api::ResourceController
  include ::BearerTokenAccessTestsHelper
  load_and_authorize_resource class: BearerTokenAccessTest

  self.model_class = BearerTokenAccessTest
end
