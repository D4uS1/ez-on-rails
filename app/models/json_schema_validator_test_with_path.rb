# frozen_string_literal: true

# Model class defining a .
class JsonSchemaValidatorTestWithPath < EzOnRails::ApplicationRecord
  self.table_name = :json_schema_validator_tests

  scoped_search on: self::search_keys

  validates :test, json_schema: {
    schema: Rails.root.join('app', 'models', 'json_schemas', 'custom_schema.json')
  }

  belongs_to :owner, class_name: 'User', optional: true
end
