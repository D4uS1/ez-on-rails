# frozen_string_literal: true

# Model class defining a NestedFormTest.
class NestedFormTest < EzOnRails::ApplicationRecord
  self.table_name = :nested_form_tests

  scoped_search on: self::search_keys

  belongs_to :parent_form_test, required: true

  has_one_attached :image

  belongs_to :owner, class_name: 'User', optional: true
end
