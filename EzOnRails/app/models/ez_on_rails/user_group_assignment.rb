# frozen_string_literal: true

# Model class defining some Assignment of an user to a group.
class EzOnRails::UserGroupAssignment < EzOnRails::AdminRecord
  self.table_name = "#{EzOnRails::ApplicationRecord::TABLE_PREFIX}user_group_assignments"

  belongs_to :user
  belongs_to :group, class_name: 'EzOnRails::Group'
  belongs_to :owner, class_name: 'User', optional: true

  validates :user, uniqueness: {
    scope: :group,
    message: I18n.t(:'ez_on_rails.group_already_assigned')
  }

  before_update :validate_update
  before_destroy :validate_destroy, prepend: true

  # Returns the assignment of the super administrator to the admin group.
  def self.super_admin_assignment
    find_by(group: EzOnRails::Group.super_admin_group, user: User.super_admin)
  end

  private

  # Validates if this resource is destroyable.
  # The resource is not destroyable if this is the assignment of the super administrator to the admin group.
  # The resource is also not destroyable if this is a member assignment.
  def validate_destroy
    if group.member_group?
      errors.add(:base, I18n.t(:'ez_on_rails.member_assignment_not_destroyable'))
      throw(:abort)
    end

    return unless group_id_was == EzOnRails::Group.super_admin_group.id && user_id_was == User.super_admin.id

    errors.add(:base, I18n.t(:'ez_on_rails.admin_assignment_not_destroyable'))
    throw(:abort)
  end

  # Validates if this resource is updateable.
  # The resource is not updateable if this is the assignment of the super administrator to the admin group.
  # The resource is also not updateable if this is a member assignment.
  def validate_update
    if group.member_group?
      errors.add(:base, I18n.t(:'ez_on_rails.member_assignment_not_updatable'))
      throw(:abort)
    end

    return unless group_id_was == EzOnRails::Group.super_admin_group.id && user_id_was == User.super_admin.id

    errors.add(:base, I18n.t(:'ez_on_rails.admin_assignment_not_updatable'))
    throw(:abort)
  end
end
