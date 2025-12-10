# frozen_string_literal: true

# Helper module for handling special translation options in EzOnRails.
module EzOnRails::EzI18nHelper
  # Returns the translation of the specified enum value in the specified model.
  # The translations are expected to be defined in some translation file, having the following structure:
  # lang:
  #   activerecord:
  #     enums:
  #       model_name:
  #         enum_name:
  #           value_key: "Translated Text"
  def human_enum_name(model_class, enum_name, value_key)
    return '' unless value_key

    I18n.t("activerecord.enums.#{model_class.to_s.underscore}.#{enum_name}.#{value_key}")
  end
end
