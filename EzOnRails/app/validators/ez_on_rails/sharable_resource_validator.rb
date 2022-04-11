# frozen_string_literal: true

# Validator that checks wether a given resource (model name) is user owned and tagged
# as sharable.
class EzOnRails::SharableResourceValidator < ActiveModel::Validator
  # validates, if the giveb resource type is a ownership info and is tagged as sharable.
  def validate(record)
    return if record.resource_type.blank?

    # Check wether ownership info exists
    ownership_info = EzOnRails::OwnershipInfo.find_by(resource: record.resource_type)
    unless ownership_info
      record.errors.add(:base, I18n.t(:'ez_on_rails.validators.sharable_resource.no_ownership_info_error'))
      return
    end

    # check wether resource is sharable
    return if ownership_info.sharable

    record.errors.add(:base, I18n.t(:'ez_on_rails.validators.sharable_resource.not_sharable_error'))
  end
end
