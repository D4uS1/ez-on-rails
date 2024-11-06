# frozen_string_literal: true

# Validator for a EzOnRails::OwnershipInfo model. Checks wether the specified resource class exists.
class EzOnRails::ModelExistsValidator < ActiveModel::Validator
  # validates, if the resource exists
  def validate(record)
    raise NameError if record.resource.blank?

    clazz = Class.const_get(record.resource)
    record.errors.add(:resource, I18n.t(:'ez_on_rails.validators.model_exists.error')) unless clazz.is_a? Class
  rescue NameError
    record.errors.add(:resource, I18n.t(:'ez_on_rails.validators.model_exists.error'))
  end
end
