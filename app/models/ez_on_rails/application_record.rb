# frozen_string_literal: true

# Base class for all application records used by ez-on-rails scaffolds.
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


  # Returns all parameters that should be wrapped in crud actions of resource controllers.
  # Wrapped parameters do not need to be passed in a subobject having the name of the model class.
  # This can be used by wrap_parameters in controllers to fix that rails does not provide active storage attachments in the wrapper per default.
  def self.wrapped_parameter_names
    attribute_names + active_storage_relation_names
  end

  # Returns all names of active storage relations that are defined for the model class.
  # This is used by the api resource controller to fix that rails does not wrap the parameters for active storage fields per default.
  def self.active_storage_relation_names
    active_storage_relations = reflect_on_all_associations.filter do |assoc|
      assoc.name.ends_with?('_attachment') || assoc.name.ends_with?('_attachments')
    end

    active_storage_relations.map do |assoc|
      assoc.name.to_s.sub('_attachments', '')
      assoc.name.to_s.sub('_attachment', '')
    end
  end
end
