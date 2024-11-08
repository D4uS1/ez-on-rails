# frozen_string_literal: true

# Model class defining the resources which are owned by the user who creates it.
class EzOnRails::OwnershipInfo < EzOnRails::AdminRecord
  self.table_name = "#{EzOnRails::ApplicationRecord::TABLE_PREFIX}ownership_infos"

  enum :on_owner_destroy, { resource_nullify: 0, resource_destroy: 1, resource_delete: 2 }

  belongs_to :owner, class_name: 'User', optional: true

  validates_with EzOnRails::ModelExistsValidator
  validates :resource, presence: true
  validates :resource, uniqueness: true

  before_validation :revise_names

  # Returns all user_owned_resoruce classes.
  def self.all_classes
    all.map { |ownership_info| Class.const_get ownership_info.resource }
  end

  # Returns the class of the resource of the ownership.
  def resource_class
    Class.const_get(resource)
  end

  private

  # Revises the Names of the this ownership info, hence it
  # is possible to use it.
  def revise_names
    self.resource = resource&.camelize
  end
end
