# frozen_string_literal: true

# Model class defining a .
class OauthClientAccessTest < EzOnRails::ApplicationRecord
  self.table_name = :oauth_client_access_tests

  scoped_search on: self::search_keys

  belongs_to :owner, class_name: 'User', optional: true
end
