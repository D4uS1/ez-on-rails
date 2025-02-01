# frozen_string_literal: true

require 'active_support/concern'

# Concern that can be included by models that should be full searchable with ransack without any restrictions.
module EzOnRails::FullRansackSearchableConcern
  extend ActiveSupport::Concern

  class_methods do
    # Returns all ransackable attributes the old way before Ransack moved to version 4
    # with new privacy by default settings, blocking all attributes by default instead
    # of allowing all by default.
    def ransackable_attributes(_auth_object = nil)
      authorizable_ransackable_attributes
    end

    # Returns all ransackable associations the old way before Ransack moved to version 4
    # with new privacy by default settings, blocking all associations by default instead
    # of allowing all by default.
    def ransackable_associations(_auth_object = nil)
      authorizable_ransackable_associations
    end
  end
end
