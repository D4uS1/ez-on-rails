# frozen_string_literal: true

# Model class defining a .
class NotUserOwnedRecord < ApplicationRecord
  self.table_name = :not_user_owned_records

  belongs_to :owner, class_name: 'User', optional: true
end
