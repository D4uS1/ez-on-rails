# frozen_string_literal: true

# Model class defining a .
class BearerTokenAccessTest < EzOnRails::ApplicationRecord
  self.table_name = :bearer_token_access_tests

  scoped_search on: self::search_keys

  has_one_attached :file
  has_many_attached :images
  belongs_to :owner, class_name: 'User', optional: true
end
