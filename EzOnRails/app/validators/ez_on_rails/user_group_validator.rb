# frozen_string_literal: true

# Validator for an EzOnRails::Group, checking whether the group is a user group and if this
# is the case, the name of the user matches the groups name.
class EzOnRails::UserGroupValidator < ActiveModel::Validator
  # validates, that the users name equals the groups name, if the user exists.
  def validate(record)
    # throw if the user did exists, but is removed
    if !record.user_id_was.nil? && record.user_id.nil?
      record.errors.add(:user, I18n.t(:'ez_on_rails.user_not_unassignable'))
    end

    return if record.user.nil? || record.user.user_group_name == record.name

    record.errors.add(:name, I18n.t(:'ez_on_rails.username_does_not_match'))
  end
end
