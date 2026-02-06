# frozen_string_literal: true

# Helper for rendering the index partial of a scaffold generated
# by the EzOnRails::EzScaff generator.
# Methods for rendering attributes should have the format
# render_{type}_show(obj, attribute_key, attribute_render_info)
# If the index partial is rendered the type for each attribute will
# be specified and the corresponding method will be called. If no method was
# found, the default method will be called to render the objects attribute.
module EzOnRails::EzScaff::ShowHelper
  THUMBNAIL_SIZE = [200, 50].freeze # Defines the size of thumbnails of active storage files
  MAX_ELEMENTS_COUNT = 3 # Defines the maximum number of shown references until a details sumary tag apperas
  DEFAULT_DATE_FORMAT = '%F %H:%M'

  # Filters the attributes from the render info which are not renderable
  # in a show form.
  def filter_attributes_show!(_obj_class, render_info)
    render_info.reject! do |_attribute_key, attribute_render_info|
      # reject if the type is password, because you should not see it
      next true if attribute_render_info[:type] && (attribute_render_info[:type] == :password)
    end
  end

  # Filters the render info to have only as nested marked fields.
  def filter_attributes_nested_show!(_obj_class, render_info)
    render_info.select! { |_attribute_key, attribute_render_info| attribute_render_info[:nested] }

    render_info
  end

  # Method for rendering a attribute whose method to the correspoinding attribute
  # type was not found.
  def render_default_show(obj, attribute_key, _attribute_render_info)
    obj.send(attribute_key)
  end

  # renders the association attribute of the specified object using the specified
  # render_info for the show partial.
  def render_association_show(obj, attribute_key, attribute_render_info)
    render_active_record_relation obj, attribute_key, attribute_render_info
  end

  # renders the association attribute of the specified object using the specified
  # render_info for the show partial.
  def render_polymorphic_association_show(obj, attribute_key, attribute_render_info)
    render_active_record_relation obj, attribute_key, attribute_render_info
  end

  # renders the nested_form attribute of the specified object using the specified
  # render_info for the show partial.
  def render_nested_form_show(obj, attribute_key, attribute_render_info)
    # securely only render the relation if the render info is a self reference, to prevent endless loops
    if attribute_render_info[:data][:render_info].is_a? String
      return render_active_record_relation obj, attribute_key, attribute_render_info
    end

    # render multiple object forms
    objs_to_render = obj.send(attribute_key)
    if objs_to_render.nil?
      objs_to_render = []
    elsif !objs_to_render.is_a? ActiveRecord::Associations::CollectionProxy
      objs_to_render = [objs_to_render]
    end

    elements = objs_to_render.map do |nested_obj|
      render partial: 'ez_on_rails/shared/nested_show', locals: {
        render_info: filter_attributes_nested_show!(nested_obj.class, attribute_render_info[:data][:render_info]),
        obj: nested_obj,
        print_controls: false,
        hide_nested_goto: attribute_render_info[:data][:hide_nested_goto]
      }
    end

    render_as_list elements, tag.hr(class: 'me-5')
  end

  # renders the attachment attribute of the specified object using the specified
  # render_info for the show partial.
  def render_attachment_show(obj, attribute_key, attribute_render_info)
    file = obj.send(attribute_key)
    return unless file.attached?

    render_active_storage_file obj.send(attribute_key), attribute_render_info[:class]
  end

  # renders the attachments attribute of the specified object using the specified
  # render_info for the show partial.
  def render_attachments_show(obj, attribute_key, attribute_render_info)
    elements = obj.send(attribute_key).map do |attachment|
      render_active_storage_file attachment, attribute_render_info[:class]
    end

    render_as_list(elements,
                   attribute_render_info[:separator] || tag.br,
                   attribute_render_info[:max_count] || MAX_ELEMENTS_COUNT)
  end

  # Renders an image hold by an active storage attachment of the given attribute in the
  # given object using the attribute_render_info.
  def render_image_show(obj, attribute_key, _attribute_render_info)
    image = obj.send(attribute_key)
    return unless image.attached?

    render_image_thumbnail obj.send(attribute_key)
  end

  # Renders images hold by an active storage multiple attachment of the given attribute in the
  # given object using the attribute_render_info.
  def render_images_show(obj, attribute_key, attribute_render_info)
    elements = obj.send(attribute_key).map do |image|
      render_image_thumbnail image
    end

    render_as_list(elements,
                   attribute_render_info[:separator] || tag.br,
                   attribute_render_info[:max_count] || MAX_ELEMENTS_COUNT)
  end

  # Renders datetime hold by an active storage attribute of the given attribute_key in the
  # given object using the attribute_render_info.
  def render_datetime_show(obj, attribute_key, attribute_render_info)
    obj.send(attribute_key)&.strftime(attribute_render_info[:format] || DEFAULT_DATE_FORMAT)
  end

  # Renders date hold by an active storage attribute of the given attribute_key in the
  # given object using the attribute_render_info.
  def render_date_show(obj, attribute_key, attribute_render_info)
    render_datetime_show obj, attribute_key, attribute_render_info
  end

  # Renders time hold by an active storage attribute of the given attribute_key in the
  # given object using the attribute_render_info.
  def render_time_show(obj, attribute_key, attribute_render_info)
    render_datetime_show obj, attribute_key, attribute_render_info
  end

  # Renders boolean hold by an active storage attribute of the given attribute_key in the
  # given object using the attribute_render_info.
  def render_boolean_show(obj, attribute_key, _attribute_render_info)
    value = obj.send(attribute_key)
    check_box_tag '', value, value, class: '', disabled: true
  end

  # Renders boolean hold by an active storage attribute of the given attribute_key in the
  # given object using the attribute_render_info.
  def render_enum_show(obj, attribute_key, attribute_render_info)
    return '' unless obj.send(attribute_key)

    human_enum_name(obj.class,
                    enum_name(attribute_key, attribute_render_info),
                    obj.send(attribute_key))
  end

  # Renders an attribute having the type :collection_select
  # Expects the attribute :data in the attribute_render_info holding the following entries:
  # :items is a set of items that will be shown as selectable list
  # :label_method is the attribute name shown as label for each item.
  def render_collection_select_show(obj, attribute_key, attribute_render_info)
    render_active_record_relation(
      obj,
      attribute_key,
      attribute_render_info.merge(label_method: attribute_render_info[:data][:label_method] || :id)
    )
  end

  # Renders an attribute having the type :duration.
  # Expects the attribute to have the ActiveSupport::Duration type.
  def render_duration_show(obj, attribute_key, _attribute_render_info)
    duration = obj.send(attribute_key)
    return '' unless duration

    duration.parts.map do |key, value|
      I18n.t(:"datetime.distance_in_words.x_#{key}.#{value == 1 ? 'one' : 'other'}", count: value)
    end.join(', ')
  end

  # Renders an attribute having the type :json.
  # Expects the attribute to have the ActiveSupport::Duration type.
  def render_json_show(obj, attribute_key, _attribute_render_info)
    obj.send(attribute_key).to_json
  end

  private

  # Renders a thumbnail of a given image stored in the active storage.
  # Clicking on the thumbnail will open a preview dialog of the image.
  def render_image_thumbnail(image)
    image_view_id = "modal_imageview_#{image.id}"

    # Render the preview modal
    res = modal_preview link_to(image_tag(image, class: 'd-block mw-100'), image),
                        id: image_view_id

    # Render the button which opens the preview modal onclick
    res += target_modal_button image_tag(image.variant(resize_to_limit: THUMBNAIL_SIZE)),
                               image_view_id,
                               class: 'd-block btn-link border p-1'

    # Return all
    res
  rescue Module::DelegationError
    ''
  end

  # Renders the specified active storage file.
  # The specified css_class is given to the element holding the content.
  def render_active_storage_file(active_storage_file, css_class = '')
    # needed because rails does not nil a nil attachment, hence it raises some stupid exception
    content_type = active_storage_file.content_type

    # If this is an image, just show it
    if content_type.include?('image')
      return link_to image_tag(active_storage_file,
                               class: "mw-100 #{css_class} border " \
                                      'rounded p-1 mb-1 mt-1'),
                     rails_blob_path(active_storage_file, disposition: 'preview')
    end

    # Otherwise show link to preview the attachment
    link_to active_storage_file.filename,
            rails_blob_path(active_storage_file, disposition: 'preview'),
            class: "text-secondary #{css_class}"
  rescue Module::DelegationError
    ''
  end

  # Renders some active record relation of the specified atribute_key in the specified object model
  # using the specified render_info.
  def render_active_record_relation(obj, attribute_key, attribute_render_info)
    # if this is as relation to many objects
    rel_objects = if obj.send(attribute_key).is_a? ActiveRecord::Associations::CollectionProxy
                    obj.send(attribute_key).map do |rel_object|
                      {
                        obj: rel_object,
                        label: get_association_label(rel_object, attribute_render_info)
                      }
                    end

                  # if this is a relation to only one object
                  else
                    assoc_object = obj.send(attribute_key)

                    [
                      {
                        obj: assoc_object,
                        label: assoc_object ? get_association_label(assoc_object, attribute_render_info) : nil
                      }
                    ]
                  end

    # Get all elements rendered in a list
    elements = if attribute_render_info[:hide_link_to]
                 rel_objects.pluck(:label)
               else
                 url_for_attr = attribute_render_info[:url_for]

                 rel_objects.map do |rel_object|
                   next nil unless rel_object[:label]

                   # no url_for method was given, just render the link to the object as target
                   next link_to rel_object[:label], rel_object[:obj], class: 'text-secondary' unless url_for_attr

                   # find url for, if custom method or string is given, take it, otherwise just the object
                   target_url = url_for_attr.is_a?(Proc) ? url_for_attr.call(rel_object) : url_for_attr
                   link_to rel_object[:label], target_url, class: 'text-secondary'
                 end
               end

    # Render the list
    render_as_list(elements || [],
                   attribute_render_info[:separator] || tag.br,
                   attribute_render_info[:max_count] || MAX_ELEMENTS_COUNT)
  end

  # Renders the given elements as list seperated by the given seperator.
  # If there are more than max_count elements, only max_counts will be rendered directly.
  # If max_count is :all, there is no maximum of elements.
  def render_as_list(elements, separator = tag.br, max_count = MAX_ELEMENTS_COUNT)
    max_count = elements.length if max_count == :all

    # Split the elements if nessecary
    detailed_elements = []
    detailed_elements = elements[max_count..] if max_count && elements.length > max_count
    elements = elements[0..(max_count - 1)] if max_count && elements.length > max_count

    # Render the element parts
    elements_html = safe_join(elements, separator)
    detailed_elements_html = safe_join(detailed_elements, separator)

    # If there are no detailed elements, just return the list
    return ActiveSupport::SafeBuffer.new(elements_html) if detailed_elements.empty?

    # Return a details summary tag
    (elements_html + tag.details(tag.summary(t(:'ez_on_rails.show_all'), class: 'mt-2 mb-1') + detailed_elements_html))
  end

  # Returns the association label from the render info.
  # If a association_show_label exists in the attribute_render_info, those label will be used.
  # If this is a block, the block will be executed by passing the object as parameter, and the blocks
  # result will be used as label.
  # If no association_label is provided, the default label_method will be used to identify the label.
  def get_association_label(obj, attr_render_info)
    if attr_render_info[:association_show_label]
      return attr_render_info[:association_show_label] if attr_render_info[:association_show_label].is_a?(String)

      return attr_render_info[:association_show_label].call(obj)
    end

    # execute the label_method as default value
    obj.send(get_label_method(attr_render_info))
  end
end
