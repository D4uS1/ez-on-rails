# frozen_string_literal: true

# Base ActiveRecord class for EzOnRails engine.
class EzOnRails::ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  TABLE_PREFIX = 'eor_'

  # Returns an array of attributes that are searchable for this record.
  # Used by the subclasses in scoped_search.
  # Can be overridden by subclasses, to provide alternative or additional search keys.
  def self.search_keys
    columns_hash.keys.map(&:to_sym)
  end

  # Returns all ransackable attributes the old way before Ransack moved to version 4
  # with new privacy by default settings, blocking all attributes by default instead
  # of allowing all by default.
  def self.ransackable_attributes
    authorizable_ransackable_attributes
  end

  # Returns all ransackable associations the old way before Ransack moved to version 4
  # with new privacy by default settings, blocking all associations by default instead
  # of allowing all by default.
  def self.ransackable_associations
    authorizable_ransackable_associations
  end
end
