# frozen_string_literal: true

# Model class defining a .
class ValidationErrorTest < EzOnRails::ApplicationRecord
  self.table_name = :validation_error_tests

  scoped_search on: self::search_keys

  validates :name, presence: true
  validates :number, presence: true

  before_destroy :check_destroy, prepend: true

  # Checks whether the name is dont_destroy, if yes the
  # operation will be aborted with an error message added to the errors.
  def check_destroy
    if name == 'dont_destroy'
      errors.add(:name, 'not destroyable')
      throw(:abort)
    end
  end

  belongs_to :owner, class_name: 'User', optional: true
end
