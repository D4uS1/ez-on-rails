# frozen_string_literal: true

# Helper for rendering the index partial of a scaffold generated
# by the EzOnRails::EzScaff generator.
# Methods for rendering attributes should have the format
# render_{type}_index(obj, attribute_key, attribute_render_info)
# If the index partial is rendered the type for each attribute will
# be specified and the corresponding method will be called. If no method was
# found, the default method will be called to render the objects attribute.
module EzOnRails::EzScaff::IndexHelper
  # Filters the attributes from the render info which are not renderable
  # in a index form.
  def filter_attributes_index!(_obj_class, render_info)
    render_info.reject! do |_attribute_key, attribute_render_info|
      # if this is a possword, remove it
      next true if attribute_render_info[:type] && attribute_render_info[:type] == :password
    end
  end

  # Renders an active storage attachment attribute of the given object, using the specified
  # attribute_render_info.
  def render_attachment_index(obj, attribute_key, attribute_render_info)
    render_attachment_show(obj, attribute_key, attribute_render_info.merge(class: 'table-thumbnail'))
  end

  # Renders an multiple active storage attachment attribute of the given object, using the specified
  # attribute_render_info.
  def render_attachments_index(obj, attribute_key, attribute_render_info)
    render_attachments_show(obj, attribute_key, attribute_render_info.merge(class: 'table-thumbnail'))
  end

  # renders the nested_form attribute of the specified object using the specified
  # render_info for the show partial.
  def render_nested_form_index(obj, attribute_key, attribute_render_info)
    render_active_record_relation obj, attribute_key, attribute_render_info
  end

  # Method for rendering a attribute whose method to the correspoinding attribute
  # type was not found.
  def render_default_index(obj, attribute_key, attribute_render_info)
    render_attribute(:show, obj, attribute_key, attribute_render_info)
  end

  # Returns the default action info for destroying resources from an selectable index table.
  # This info hash can be passed to an action array of the index action to render the
  # button to destroy the selections.
  def destroy_selections_action_button
    {
      label: icon_with_text('trash', t(:'ez_on_rails.destroy_selection')),
      type: 'danger',
      method: :delete,
      target: {
        controller: controller_name,
        action: :destroy_selections
      },
      confirm: true
    }
  end

  # Returns the default selectable actions info for resources from an selectable index table.
  # This info hash can be passed to an selectable field of the index action to render the
  # button to perform some actions like destroy selections.
  # If the actions are not accessible by the current user, the action will not be visible.
  # If no action is accessibkle, nil will be returned, hence the table would not be selectable.
  def default_selectable_info
    # create action buttons array
    actions = []
    actions.push destroy_selections_action_button if access_to_action_in_path? controller_name, :destroy_selections

    # return nil if no action was accessible
    return nil if actions.empty?

    # return the info hash for selectable table
    {
      actions: actions
    }
  end
end
