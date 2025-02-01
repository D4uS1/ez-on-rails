# frozen_string_literal: true

# Validator for an EzOnRails::Group.
class EzOnRails::UserGroupValidator < ActiveModel::Validator
  # Validates that the users name equals the groups name, if the user exists.
  # Validates that if some resource access flag is set, resource_group flag must be set, too.
  def validate(record)
    validate_group_name(record)
    validate_resource_access_flags(record)
  end

  # Validates that the users name equals the groups name, if the user exists.
  def validate_group_name(record)
    # throw if the user did exists, but is removed
    if !record.user_id_was.nil? && record.user_id.nil?
      record.errors.add(:user, I18n.t(:'ez_on_rails.user_not_unassignable'))
    end

    return if record.user.nil? || record.user.user_group_name == record.name

    record.errors.add(:name, I18n.t(:'ez_on_rails.username_does_not_match'))
  end

  # Validates that if some resource access flag is set, resource_group flag must be set, too.
  def validate_resource_access_flags(record)
    return unless record.resource_read || record.resource_write || record.resource_destroy

    record.errors.add(:resource_group, I18n.t(:'ez-on-rails.group_no_resource_group')) unless record.resource_group
  end
end
