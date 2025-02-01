# frozen_string_literal: true

# Model class defining a .
class UserOwnedRecord < ApplicationRecord
  self.table_name = :user_owned_records

  belongs_to :owner, class_name: 'User', optional: true
end
