# frozen_string_literal: true

# Model class defining a .
class SharableResource < ApplicationRecord
  self.table_name = :sharable_resources

  belongs_to :owner, class_name: 'User', optional: true

  has_many :read_accesses, class_name: 'EzOnRails::ResourceReadAccess', dependent: :destroy, as: :resource
  has_many :read_accessible_groups,
           through: :read_accesses,
           source: :group,
           class_name: 'EzOnRails::Group'
  has_many :write_accesses, class_name: 'EzOnRails::ResourceWriteAccess', dependent: :destroy, as: :resource
  has_many :write_accessible_groups,
           through: :write_accesses,
           source: :group,
           class_name: 'EzOnRails::Group'
  has_many :destroy_accesses, class_name: 'EzOnRails::ResourceDestroyAccess', dependent: :destroy,  as: :resource
  has_many :destroy_accessible_groups,
           through: :destroy_accesses,
           source: :group,
           class_name: 'EzOnRails::Group'

  def self.polymorphic_name
    'SharableResource'
  end
end
