# frozen_string_literal: true

# Controller class for a ValidationErrorTest resource.
class Api::ValidationErrorTestsController < EzOnRails::Api::ResourceController
  include ::ValidationErrorTestsHelper
  load_and_authorize_resource class: ValidationErrorTest

  self.model_class = ValidationErrorTest

  protected

  # Overwrites the default order.
  def default_order
    { name: :desc }
  end
end
