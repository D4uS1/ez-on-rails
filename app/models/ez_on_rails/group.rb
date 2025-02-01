# frozen_string_literal: true

# Model class defining a group.
class EzOnRails::Group < EzOnRails::AdminRecord
  self.table_name = "#{EzOnRails::ApplicationRecord::TABLE_PREFIX}groups"

  SUPER_ADMIN_GROUP_NAME = 'SuperAdmin'
  MEMBER_GROUP_NAME = 'Member'

  has_many :user_group_assignments,
           class_name: 'EzOnRails::UserGroupAssignment',
           dependent: :destroy
  has_many :users,
           through: :user_group_assignments
  has_many :group_accesses,
           class_name: 'EzOnRails::GroupAccess',
           dependent: :destroy

  # relations for the sharing and ownership system
  has_many :resource_read_accesses,
           class_name: 'EzOnRails::ResourceReadAccess',
           dependent: :destroy
  has_many :resource_write_accesses,
           class_name: 'EzOnRails::ResourceWriteAccess',
           dependent: :destroy
  has_many :resource_destroy_accesses,
           class_name: 'EzOnRails::ResourceDestroyAccess',
           dependent: :destroy

  # defined if this is a user_group
  belongs_to :user, optional: true

  belongs_to :owner, class_name: 'User', optional: true

  validates :name, presence: true
  validates :name, uniqueness: true
  validates_with EzOnRails::UserGroupValidator

  before_update :validate_update
  before_destroy :validate_destroy, prepend: true

  # Returns whether this is the admin group.
  def super_admin_group?
    name == SUPER_ADMIN_GROUP_NAME
  end

  # Returns wether this is the member group.
  def member_group?
    name == MEMBER_GROUP_NAME
  end

  # Returns the admin group.
  def self.super_admin_group
    find_by(name: SUPER_ADMIN_GROUP_NAME)
  end

  # Returns the member group
  def self.member_group
    find_by(name: MEMBER_GROUP_NAME)
  end

  private

  # Validates if this resource is destroyable.
  # The member group and the admin group are not destroyable.
  # If this is a user_group, the record is not destroyable.
  def validate_destroy
    if member_group?
      errors.add(:base, I18n.t(:'ez_on_rails.member_group_not_destroyable'))
      throw(:abort)
    end

    if user
      errors.add(:base, I18n.t(:'ez_on_rails.user_group_not_destroyable'))
      throw(:abort)
    end

    return unless super_admin_group?

    errors.add(:base, I18n.t(:'ez_on_rails.super_admin_group_not_destroyable'))
    throw(:abort)
  end

  # Validates if this resource is updateable.
  # The member group and the admin group are not updateable.
  def validate_update
    if name_was == MEMBER_GROUP_NAME && name != MEMBER_GROUP_NAME
      errors.add(:base, I18n.t(:'ez_on_rails.member_group_not_updatable'))
      throw(:abort)
    end

    return unless name_was == SUPER_ADMIN_GROUP_NAME && name != SUPER_ADMIN_GROUP_NAME

    errors.add(:base, I18n.t(:'ez_on_rails.super_admin_group_not_updatable'))
    throw(:abort)
  end
end
