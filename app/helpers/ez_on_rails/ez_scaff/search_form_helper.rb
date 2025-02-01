# frozen_string_literal: true

# Helper for rendering the search_form partial of a scaffold generated
# by the EzOnRails::EzScaff generator.
# Methods for rendering attributes should have the format
# render_{type}_model_form(obj, attribute_key, attribute_render_info)
# If the index partial is rendered the type for each attribute will
# be specified and the corresponding method will be called. If no method was
# found, the default method will be called to render the objects attribute.
module EzOnRails::EzScaff::SearchFormHelper
  FIELDS_PER_ROW = 3 # Defines the number of fields shown in the search form per row

  # Filters the attributes from the render info which are not renderable
  # in a search form.
  def filter_attributes_search_form!(obj_class, render_info)
    render_info.reject! do |attribute_key, attribute_render_info|
      # attachments are not searchable
      next unless %i[attachment attachments image images].include?(
        attribute_type(obj_class, attribute_key, attribute_render_info)
      )

      next true
    end
  end

  # Renders a container tag holding the attribute of the current form data having the
  # attribute_key and the specified attribute_render_info. The specified block is yielded
  # into the container.
  def render_attribute_container_search_form(_data, _attribute_key, _attribute_render_info, &)
    tag.div(class: 'mb-3', &)
  end

  # Method for rendering an attachment attribute in a search form.
  # data expects the :form, :search_method and :obj_class.
  # :obj_class is the class of the active record which contains the attribute :attribute_key.
  # :form is the search form builder.
  def render_attachment_search_form(data, attribute_key, attribute_render_info)
    data[:form].search_field search_association_key(attribute_key,
                                                    attribute_render_info.merge(label_method: :blob_filename)),
                             class: attribute_classes_search_form(attribute_render_info)
  end

  # Method for rendering an attachments attribute in a search form.
  # data expects the :form, :search_method and :obj_class.
  # :obj_class is the class of the active record which contains the attribute :attribute_key.
  # :form is the search form builder.
  def render_attachments_search_form(data, attribute_key, attribute_render_info)
    render_attachment_search_form(data, attribute_key, attribute_render_info)
  end

  # Method for rendering an image attribute in a search form.
  # data expects the :form, :search_method and :obj_class.
  # :obj_class is the class of the active record which contains the attribute :attribute_key.
  # :form is the search form builder.
  def render_image_search_form(data, attribute_key, attribute_render_info)
    render_attachment_search_form(data, attribute_key, attribute_render_info)
  end

  # Method for rendering an images attribute in a search form.
  # data expects the :form, :search_method and :obj_class.
  # :obj_class is the class of the active record which contains the attribute :attribute_key.
  # :form is the search form builder.
  def render_images_search_form(data, attribute_key, attribute_render_info)
    render_attachments_search_form(data, attribute_key, attribute_render_info)
  end

  # Method for rendering a attribute whose method to the correspoinding attribute
  # type was not found.
  # data expects the :form, :search_method and :obj_class.
  # :obj_class is the class of the active record which contains the attribute :attribute_key.
  # :form is the search form builder.
  def render_default_search_form(data, attribute_key, attribute_render_info)
    data[:form].search_field search_attribute_key(attribute_key, attribute_render_info),
                             class: attribute_classes_search_form(attribute_render_info)
  end

  # Method for rendering an association attribute in a search form.
  # data expects the :form, :search_method and :obj_class.
  # :obj_class is the class of the active record which contains the attribute :attribute_key.
  # :form is the search form builder.
  def render_association_search_form(data, attribute_key, attribute_render_info)
    text_field = data[:form].search_field search_association_key(attribute_key, attribute_render_info),
                                          class: attribute_classes_search_form(attribute_render_info)

    # field for existence
    existence_search_key = :"#{attribute_key}_id_null"
    boolean_field = data[:form].select existence_search_key,
                                       options_for_select([
                                                            ['', ''],
                                                            [t(:'ez_on_rails.association_exists_not'), 'true'],
                                                            [t(:'ez_on_rails.association_exists'), 'false']
                                                          ], data[:form].object.send(existence_search_key)),
                                       {},
                                       class: 'form-select mt-1'

    text_field + boolean_field
  end

  # Method for rendering a polymorphic association attribute in a search form.
  # data expects the :form, :search_method and :obj_class.
  # :obj_class is the class of the active record which contains the attribute :attribute_key.
  # :form is the search form builder.
  def render_polymorphic_association_search_form(data, attribute_key, attribute_render_info)
    render_association_search_form(data, attribute_key, attribute_render_info)
  end

  # Method for rendering an nested form association in as search form.
  # data expects the :form, :search_method and :obj_class.
  # :obj_class is the class of the active record which contains the attribute :attribute_key.
  # :form is the search form builder.
  def render_nested_form_search_form(data, attribute_key, attribute_render_info)
    render_association_search_form(data, attribute_key, attribute_render_info)
  end

  # Method for rendering a boolean attribute in a search form.
  # data expects the :form, :search_method and :obj_class.
  # :obj_class is the class of the active record which contains the attribute :attribute_key.
  # :form is the search form builder.
  def render_boolean_search_form(data, attribute_key, attribute_render_info)
    # identify search key
    search_key = search_attribute_key(attribute_key, attribute_render_info.merge(search_method: :eq))

    # print dropdown with options for yes no and yes or no and use the search key for the default value
    data[:form].select search_key,
                       options_for_select([
                                            [t(:'ez_on_rails.yes_or_no'), ''],
                                            [t(:yes), 'true'],
                                            [t(:no), 'false']
                                          ], data[:form].object.send(search_key)),
                       {},
                       class: 'form-control'
  end

  # Method for rendering a enum attribute in a search form.
  # data expects the :form, :search_method and :obj_class.
  # :obj_class is the class of the active record which contains the attribute :attribute_key.
  # :form is the search form builder.
  def render_enum_search_form(data, attribute_key, attribute_render_info)
    # identify search key
    search_key = search_attribute_key(attribute_key, attribute_render_info.merge(search_method: :eq))

    # get enum name
    enum_name = enum_name attribute_key, attribute_render_info
    model_class = data[:form].object.klass

    # convert enum object to array of selection
    collection = [['', '']]
    model_class.send(enum_name.pluralize).each do |key, value|
      collection << [human_enum_name(model_class, enum_name, key), value]
    end

    data[:form].select search_key,
                       options_for_select(collection, data[:form].object.send(search_key)),
                       {},
                       { class: 'form-control' }
  end

  # returns the default css classes for some attribute in a search form.
  def attribute_classes_search_form(attribute_render_info)
    "#{attribute_render_info[:class] || ''} form-control"
  end

  private

  # Returns the attribute key for the search form of the given attribute_key.
  # If no :search_method key is specified in the render_info, :cont will be used.
  def search_attribute_key(attribute_key, attribute_render_info)
    :"#{attribute_key}_#{attribute_render_info[:search_method] || 'cont'}"
  end

  # Returns the attribute key for the search form of the given attribute_key, which is an association.
  # If association_search_attributes is defined, a search key having those attributes being combined
  # with or and using the cont search method will be used.
  # Otherwise the default label method will be combined with a search_method that can also be defined
  # in the render info. if no :search_method key is specified in the render_info, :cont will be used.
  def search_association_key(attribute_key, attribute_render_info)
    search_method = attribute_render_info[:search_method]

    # if association_search_attributes is defined, just use them
    target_attributes = attribute_render_info[:association_search_attributes]&.map(&:to_s)
    if target_attributes
      join_str = "_or_#{attribute_key}_"
      return :"#{attribute_key}_#{target_attributes.join(join_str)}_#{search_method || 'cont'}"
    end

    # otherwise, first specify the label method
    label_method = get_label_method(attribute_render_info)

    # if the label method is id, use eq
    return :"#{attribute_key}_id_#{search_method || 'eq'}" if label_method == :id

    # otherwise the label_method to specify the key
    :"#{attribute_key}_#{label_method}_#{search_method || 'cont'}"
  end
end
