# frozen_string_literal: true

# Model class defining a PropertiesTest.
class PropertiesTest < EzOnRails::ApplicationRecord
  self.table_name = :properties_tests

  scoped_search on: self::search_keys

  belongs_to :assoc_test, required: true
  belongs_to :owner, class_name: 'User', optional: true
end
