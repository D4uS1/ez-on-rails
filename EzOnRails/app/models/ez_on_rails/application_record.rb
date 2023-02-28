# frozen_string_literal: true

# Base ActiveRecord class for EzOnRails engine.
class EzOnRails::ApplicationRecord < ActiveRecord::Base
  include EzOnRails::FullRansackSearchableConcern

  self.abstract_class = true

  TABLE_PREFIX = 'eor_'

  # Returns an array of attributes that are searchable for this record.
  # Used by the subclasses in scoped_search.
  # Can be overridden by subclasses, to provide alternative or additional search keys.
  def self.search_keys
    columns_hash.keys.map(&:to_sym)
  end
end
