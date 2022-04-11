# frozen_string_literal: true

# Controller class for a ValidationErrorTest resource.
class Api::ValidationErrorTestsController < EzOnRails::Api::ResourceController
  include ::ValidationErrorTestsHelper
  load_and_authorize_resource class: ValidationErrorTest

  self.model_class = ValidationErrorTest
end
