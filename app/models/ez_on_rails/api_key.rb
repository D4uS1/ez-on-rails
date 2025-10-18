# frozen_string_literal: true

# Model class defining a group.
class EzOnRails::ApiKey < EzOnRails::AdminRecord
  self.table_name = "#{EzOnRails::ApplicationRecord::TABLE_PREFIX}api_keys"

  belongs_to :owner, class_name: 'User', optional: true

  validates :api_key, presence: true
  validates :api_key, uniqueness: true

  before_validation :generate_api_key

  protected

  # Generates a new api key if it is not set.
  def generate_api_key
    return if api_key.present?

    self.api_key = SecureRandom.base58(64)
  end
end
