# frozen_string_literal: true

# Model class defining a .
class JsonSchemaValidatorTest < EzOnRails::ApplicationRecord
  self.table_name = :json_schema_validator_tests

  scoped_search on: self::search_keys
  
  validates :test, json_schema: true

  belongs_to :owner, class_name: 'User', optional: true
end
