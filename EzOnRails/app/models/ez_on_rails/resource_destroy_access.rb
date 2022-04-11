# frozen_string_literal: true

# Model class for relationship table between some resource and group.
# If the relation is set, users in the group are allowed to destroy the resource.
class EzOnRails::ResourceDestroyAccess < EzOnRails::ApplicationRecord
  self.table_name = "#{EzOnRails::ApplicationRecord::TABLE_PREFIX}resource_destroy_accesses"

  scoped_search on: search_keys

  belongs_to :resource, polymorphic: true
  belongs_to :group, class_name: 'EzOnRails::Group'

  validates_with EzOnRails::SharableResourceValidator
end
