# frozen_string_literal: true

# Helper Module for Broom Closet Views.
module EzOnRails::Admin::BroomCloset::BroomClosetHelper
  # renders a search field for broom closet views.
  # The given attribute_key is expected to be a symbol of the field to search.
  def broom_closet_search_field(attribute_key, search_method = 'cont')
    # specify keys
    attribute_key = attribute_key.to_s
    search_key = "#{attribute_key}_#{search_method}"

    # get default value, if available in params
    default_value = params['q'][attribute_key] if params['q']

    # render field
    tag.input id: "q_#{search_key}",
              name: "q[#{search_key}",
              class: 'form-control',
              value: default_value
  end
end
