# frozen_string_literal: true

# Validator for an EzOnRails::User, checking whether the name of the resulting user group after the
# user was created or updated exists.
class EzOnRails::UserGroupNameValidator < ActiveModel::Validator
  # validates, that the user group holding the name of the specified user records
  # user_group_name does not exist.
  def validate(record)
    return unless EzOnRails::Group.exists?(name: record.user_group_name)

    record.errors.add(:base, I18n.t(:user_group_exists_error))
  end
end
