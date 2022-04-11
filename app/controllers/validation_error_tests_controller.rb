# frozen_string_literal: true

# Controller class for a  resource.
class ValidationErrorTestsController < EzOnRails::ResourceController
  include ValidationErrorTestsHelper

  load_and_authorize_resource class: ValidationErrorTest

  before_action :breadcrumb_validation_error_test
  self.model_class = ValidationErrorTest

  protected

  # Sets the breadcrumb to the index action of the controllers resource.
  def breadcrumb_validation_error_test
    breadcrumb ValidationErrorTest.model_name.human(count: 2),
               controller: '/validation_error_tests',
               action: 'index'
  end
end
