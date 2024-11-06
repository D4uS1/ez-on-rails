# frozen_string_literal: true

# Model class defining a AssocTest.
class AssocTest < EzOnRails::ApplicationRecord
  self.table_name = :assoc_tests

  scoped_search on: self::search_keys

  belongs_to :bearer_token_access_test, required: true
  belongs_to :parent_form_test, required: true
  belongs_to :owner, class_name: 'User', optional: true
end
