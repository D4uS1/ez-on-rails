# frozen_string_literal: true

# Model class defining Access abilities for a group.
# A group has access to a namespace, controller or action if some access definition
# to that resource defined by this class exists.
class EzOnRails::GroupAccess < EzOnRails::AdminRecord
  self.table_name = "#{EzOnRails::ApplicationRecord::TABLE_PREFIX}group_accesses"

  # saves empty strings as nil, needed because in the access checks we are accessing data
  # using where clauses like EzOnRails::GroupAccess.where(action: action). If action is nil but the value
  # in the database is empty string, this would not work.
  # IMPORTANT NOTE: If nilify_blanks will be removed, eg. because of an update, you need to
  # change the access_check methods accessing the data to get sure that both, empty string and nil works
  nilify_blanks

  ADMIN_AREA_NAMESPACE = 'ez_on_rails/admin'

  belongs_to :group, class_name: 'EzOnRails::Group'
  belongs_to :owner, class_name: 'User', optional: true

  validates_with EzOnRails::PathExistsValidator
  validates_with EzOnRails::PathCorrectnessValidator
  validates :group, uniqueness: {
    scope: %i[namespace controller action],
    message: I18n.t(:'ez_on_rails.group_access_already_exists')
  }

  before_validation :revise_names
  before_update :validate_update
  before_destroy :validate_destroy, prepend: true

  # returns the admin area group_access object.
  def self.admin_area
    find_by(group: EzOnRails::Group.super_admin_group, namespace: ADMIN_AREA_NAMESPACE, controller: nil, action: nil)
  end

  private

  # Validates if this resource is destroyable.
  # This resource is not destroyable if it is the admin area restricting resource.
  def validate_destroy
    return unless group.super_admin_group? && namespace == ADMIN_AREA_NAMESPACE && controller.nil? && action.nil?

    errors.add(:base, I18n.t(:'ez_on_rails.admin_group_access_not_destroyable'))
    throw(:abort)
  end

  # Validates if this resource is updatable.
  # This resource is not updateable, if this was the admin namespace restricting resource.
  def validate_update
    return unless group_id_was == EzOnRails::Group.super_admin_group.id
    return unless namespace_was == ADMIN_AREA_NAMESPACE && controller_was.nil? && action_was.nil?

    errors.add(:base, I18n.t(:'ez_on_rails.admin_group_access_not_updatable'))
    throw(:abort)
  end

  # Revises the given names for the this object, hence the namespaces, controllers
  # and actions have the correct rails naming conventions.
  def revise_names
    # correct namespace
    self.namespace = revise_name namespace if namespace.present?

    # correct controller
    self.controller = revise_name controller if controller.present?

    # correct action
    self.action = revise_name action if action.present?
  end

  # Revives the given name by changing the text, hence the name has
  # the correct rails naming conventions.
  def revise_name(name)
    name = name.underscore
    name = (name[0] == '/' ? name[1..] : name)
    name[-1] == '/' ? name[0..-2] : name
  end
end
