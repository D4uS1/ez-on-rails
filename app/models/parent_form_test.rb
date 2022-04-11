# frozen_string_literal: true

# Model class defining a ParentFormTest.
class ParentFormTest < EzOnRails::ApplicationRecord
  self.table_name = :parent_form_tests

  scoped_search on: self::search_keys

  has_many :nested_form_tests, dependent: :destroy

  accepts_nested_attributes_for :nested_form_tests, allow_destroy: true

  belongs_to :owner, class_name: 'User', optional: true
end
