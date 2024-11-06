# frozen_string_literal: true

# Validator for a EzOnRails::GroupAccess model to check whether the given path in the given namespace,
# controller and action exists.
class EzOnRails::PathExistsValidator < ActiveModel::Validator
  # Validates the given EzOnRails::GroupAccess record
  # Checks wether the given action, controller and namespace exists.
  def validate(record)
    # check if at least one value (namespace, controller) is given
    if record.namespace.blank? && record.controller.blank?
      record.errors.add(:base, I18n.t(:'ez_on_rails.validators.path_exists.no_namespace_and_controller'))
      return
    end

    # if an action is given, check wether teh path to the action exists
    if record.action.present?
      validate_action_exists record
      return
    end

    # if a controller without an action is given, check wether the controller exists
    if record.controller.present?
      validate_controller_exists record
      return
    end

    # if a namespace without a controller is given, check wether the namespace exists
    validate_namespace_exists record if record.namespace
  end

  # Returns whether the defined action in the given record exists.
  # if not, an error will be added to the records errors.
  def validate_action_exists(record)
    # an action without controller should not exists
    if record.controller.blank?
      record.errors.add(:controller, I18n.t(:'ez_on_rails.validators.path_exists.action_without_controller'))
      return
    end

    # get the controller class
    full_controller_name = controller_class_name record
    clazz = Module.const_get full_controller_name

    # check whether action method exists
    return if clazz.action_methods.include? record.action

    record.errors.add(:base, I18n.t(:'ez_on_rails.validators.path_exists.route_not_existent'))
  rescue NameError
    record.errors.add(:base, I18n.t(:'ez_on_rails.validators.path_exists.route_not_existent'))
  end

  # Returns wether the defined controller in the given record exists.
  # if not, an error will be added to the records errors.
  def validate_controller_exists(record)
    full_controller_name = controller_class_name record
    clazz = Module.const_get full_controller_name

    return if clazz.is_a? Class

    record.errors.add(:controller, I18n.t(:'ez_on_rails.validators.path_exists.controller_not_existent'))
  rescue NameError
    record.errors.add(:controller, I18n.t(:'ez_on_rails.validators.path_exists.controller_not_existent'))
  end

  # Returns wether the defined namespace in the given record exists.
  # if not, an error will be added to the records errors.
  def validate_namespace_exists(record)
    ns = Module.const_get record.namespace.camelize.gsub('/', '::')

    return if ns.is_a? Module

    record.errors.add(:namespace, I18n.t(:'ez_on_rails.validators.path_exists.namespace_not_existent'))
  rescue NameError
    record.errors.add(:namespace, I18n.t(:'ez_on_rails.validators.path_exists.namespace_not_existent'))
  end

  private

  # Returns the name of the class of the controller defined by the record.
  def controller_class_name(record)
    # Controller name having namespace if exists
    full_controller_name = record.controller.camelize
    if record.namespace.present?
      full_controller_name = "#{record.namespace.camelize.gsub('/', '::')}::#{full_controller_name}"
    end

    # Append Controller if name does not end with controller
    full_controller_name = "#{full_controller_name}Controller" unless full_controller_name.end_with? 'Controller'

    full_controller_name
  end
end
