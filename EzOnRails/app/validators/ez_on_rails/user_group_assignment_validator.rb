# frozen_string_literal: true

# Validator for an EzOnRails::UserGroupAssignment.
class EzOnRails::UserGroupAssignmentValidator < ActiveModel::Validator
  # Validates that if a resource is assigned, the group needs to be marked as resource group.
  def validate(record)
    return unless record.resource

    record.errors.add(:group, I18n.t(:'ez-on-rails.group_no_resource_group')) unless record.group&.resource_group
  end
end
