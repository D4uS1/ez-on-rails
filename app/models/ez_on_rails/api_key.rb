# frozen_string_literal: true

# Model class defining a group.
class EzOnRails::ApiKey < EzOnRails::AdminRecord
  self.table_name = "#{EzOnRails::ApplicationRecord::TABLE_PREFIX}api_keys"

  belongs_to :owner, class_name: 'User', optional: true

  validates :api_key, presence: true
  validates :api_key, uniqueness: true
end
