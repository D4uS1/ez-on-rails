# frozen_string_literal: true

# Controller class for a  resource.
class JsonSchemaValidatorTestsController < EzOnRails::ResourceController
  include JsonSchemaValidatorTestsHelper

  load_and_authorize_resource class: JsonSchemaValidatorTest

  before_action :breadcrumb_json_schema_validator_test
  self.model_class = JsonSchemaValidatorTest

  protected

  # Sets the breadcrumb to the index action of the controllers resource.
  def breadcrumb_json_schema_validator_test
    breadcrumb JsonSchemaValidatorTest.model_name.human(count: 2),
               controller: '/json_schema_validator_tests',
               action: 'index'
  end

  # Overwrites the ez-on-rails method to provide additional permit params.
  # Used to add the json field content here.
  def additional_permit_params
    [
      test: [:not_nullable_integer, :nullable_string ],
    ]
  end
end
