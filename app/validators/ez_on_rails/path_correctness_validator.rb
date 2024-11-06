# frozen_string_literal: true

# Validator for a EzOnRails::GroupAccess model. Checks wether the path was given correctly,
# without namespaces in controller and action.
class EzOnRails::PathCorrectnessValidator < ActiveModel::Validator
  # validates, if the path was defined correctly, without namesapces in action or controller.
  def validate(record)
    if !record.action.nil? && includes_namespaces?(record.action)
      record.errors.add(:action, I18n.t(:'ez_on_rails.validators.path_correctness.action_error'))
    end

    return if record.controller.nil? || !includes_namespaces?(record.controller)

    record.errors.add(:controller, I18n.t(:'ez_on_rails.validators.path_correctness.controller_error'))
  end

  # Checks wether the given text has namespaces.
  def includes_namespaces?(text)
    text.include?('::') || text.include?('/')
  end
end
