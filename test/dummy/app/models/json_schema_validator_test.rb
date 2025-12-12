# frozen_string_literal: true

# Model class defining a JsonSchemaValidatorTest.
class JsonSchemaValidatorTest < EzOnRails::ApplicationRecord
  self.table_name = :json_schema_validator_tests

  scoped_search on: self::search_keys

  belongs_to :owner, class_name: 'User', optional: true

  # associations for the resource_groups access system
  has_many :user_group_assignments, as: :resource, class_name: 'EzOnRails::UserGroupAssignment', dependent: :destroy
  has_many :groups, through: :user_group_assignments, class_name: 'EzOnRails::Group'

  validates :test, json_schema: true
end
