# frozen_string_literal: true

# Helper for rendering the model_form partial of a scaffold generated
# by the EzOnRails::EzScaff generator.
# Methods for rendering attributes should have the format
# render_{type}_model_form(obj, attribute_key, attribute_render_info)
# If the index partial is rendered the type for each attribute will
# be specified and the corresponding method will be called. If no method was
# found, the default method will be called to render the objects attribute.
module EzOnRails::EzScaff::ModelFormHelper
  FILE_UPLOAD_MAX_SIZE = 5_242_880 # maximum filesize in bytes for file upload components
  MAX_FILES_COUNT = 10 # default maximum amount of uploadable files in upload components

  # Filters the render info to have only as nested marked fields.
  def filter_attributes_nested_model_form!(_obj_class, render_info)
    render_info.select! { |_attribute_key, attribute_render_info| attribute_render_info[:nested] }

    render_info
  end

  # Renders a container tag holding the attribute of the current form object having the
  # attribute_key and the specified attribute_render_info. The specified block is yielded
  # into the container.
  def render_attribute_container_model_form(_form, _attribute_key, _attribute_render_info, &)
    tag.div(class: 'mb-4 mt-1', &)
  end

  # Method for rendering a attribute whose method to the correspoinding attribute
  # type was not found.
  def render_default_model_form(form, attribute_key, attribute_render_info)
    form.text_field attribute_key, html_options_model_form(form, attribute_key, attribute_render_info)
  end

  # renders the boolean attribute of the specified form builder using the specified
  # render_info for the model_form partial.
  def render_boolean_model_form(form, attribute_key, attribute_render_info)
    html_options = html_options_model_form(form, attribute_key, attribute_render_info)

    # provide the checkbox from being oversized
    html_options[:class] = html_options[:class]&.sub('form-control', 'form-check-input me-2')

    form.check_box attribute_key, html_options
  end

  # renders the time attribute of the specified form builder using the specified
  # render_info for the model_form partial.
  def render_time_model_form(form, attribute_key, attribute_render_info)
    form.datetime_field attribute_key, html_options_model_form(form, attribute_key, attribute_render_info)
  end

  # renders the integer attribute of the specified form builder using the specified
  # render_info for the model_form partial.
  def render_integer_model_form(form, attribute_key, attribute_render_info)
    form.number_field attribute_key, html_options_model_form(form, attribute_key, attribute_render_info)
  end

  # renders the float attribute of the specified form builder using the specified
  # render_info for the model_form partial.
  def render_float_model_form(form, attribute_key, attribute_render_info)
    form.number_field attribute_key,
                      html_options_model_form(form, attribute_key, attribute_render_info).merge(step: 0.01)
  end

  # renders the float attribute of the specified form builder using the specified
  # render_info for the model_form partial.
  def render_decimal_model_form(form, attribute_key, attribute_render_info)
    render_float_model_form form, attribute_key, attribute_render_info
  end

  # renders the text attribute of the specified form builder using the specified
  # render_info for the model_form partial.
  def render_text_model_form(form, attribute_key, attribute_render_info)
    form.text_area attribute_key, html_options_model_form(form, attribute_key, attribute_render_info)
  end

  # renders the password attribute of the specified form builder using the specified
  # render_info for the model_form partial.
  def render_password_model_form(form, attribute_key, attribute_render_info)
    form.password_field attribute_key, html_options_model_form(form, attribute_key, attribute_render_info)
  end

  # renders the date attribute of the specified form builder using the specified
  # render_info for the model_form partial.
  def render_date_model_form(form, attribute_key, attribute_render_info)
    form.date_field attribute_key, html_options_model_form(form, attribute_key, attribute_render_info)
  end

  # renders the datetimne attribute of the specified form builder using the specified
  # render_info for the model_form partial.
  def render_datetime_model_form(form, attribute_key, attribute_render_info)
    form.datetime_field attribute_key, html_options_model_form(form, attribute_key, attribute_render_info)
  end

  # renders the select attribute of the specified form builder using the specified
  # render_info for the model_form partial.
  def render_select_model_form(form, attribute_key, attribute_render_info)
    form.select attribute_key,
                attribute_render_info[:data],
                {},
                html_options_model_form(form, attribute_key, attribute_render_info)
  end

  # renders the combobox attribute of the specified form builder using the specified
  # render_info for the model_form partial.
  def render_combobox_model_form(form, attribute_key, attribute_render_info)
    # Add combobox to default classes
    html_options = html_options_model_form form, attribute_key, attribute_render_info
    html_options[:class] = "#{html_options[:class]} combobox"

    # render the field
    form.select attribute_key,
                attribute_render_info[:data],
                {},
                html_options
  end

  # renders the association attribute of the specified form builder using the specified
  # render_info for the model_form partial.
  def render_association_model_form(form, attribute_key, attribute_render_info)
    # identify the label method
    label_method = get_label_method(attribute_render_info)

    # identify the display type and css
    display_type = attribute_render_info[:render_as] || :combobox
    html_options = html_options_model_form form, attribute_key, attribute_render_info
    html_options[:class] = "#{html_options[:class]} combobox" if display_type == :combobox

    options = {
      label_method:,
      as: (display_type == :combobox ? :select : display_type),
      input_html: html_options
    }
    options[:collection] = attribute_render_info[:data] if attribute_render_info[:data]

    form.association attribute_key,
                     **options
  end

  # Renders the polymorphic association attribute of the specified form builder using the
  # specified render_info for the model_form partial.
  def render_polymorphic_association_model_form(form, attribute_key, attribute_render_info)
    render_polymorphic_association_field(form, attribute_key, attribute_render_info)
  end

  # renders the nested_form attribute of the specified form builder using the specified
  # render_info for the model_form partial.
  def render_nested_form_model_form(form, attribute_key, attribute_render_info)
    # find the class for the nested form object
    relation_reflection = form.object.class.reflect_on_association(attribute_key)

    # get the render_info from nested fields
    nested_render_info = if attribute_render_info[:data][:render_info].is_a? Hash
                           filter_attributes! :nested_model_form,
                                              relation_reflection.klass,
                                              attribute_render_info[:data][:render_info]
                         else
                           filter_attributes! :nested_model_form,
                                              relation_reflection.klass,
                                              send(attribute_render_info[:data][:render_info])
                         end

    # render nested fields
    content_fields = form.simple_fields_for attribute_key do |nested_form_builder|
      render attribute_render_info[:data][:partial] || 'ez_on_rails/shared/nested_model_form',
             form: nested_form_builder,
             render_info: nested_render_info,
             obj: nested_form_builder.object,
             hide_remove: attribute_render_info[:data][:hide_remove] || false
    end

    # render add link if should not be hidden
    content_links = ''
    unless attribute_render_info[:data][:hide_add]
      content_links = tag.div(
        link_to_add_association(
          t(:'ez_on_rails.add_nested_form', nested_model: attribute_render_info[:label].singularize),
          form,
          attribute_key,
          partial: attribute_render_info[:data][:partial] || 'ez_on_rails/shared/nested_model_form',
          form_name: 'form',
          render_options: {
            locals: {
              render_info: nested_render_info,
              obj: relation_reflection.klass.new,
              hide_remove: attribute_render_info[:data][:hide_remove] || false
            }
          },
          # this prevents cocoon from deleting the has_one relation on visiting the edit page,
          # see https://stackoverflow.com/questions/25870978/cocoon-and-has-one-association
          force_non_association_create: relation_reflection.has_one?
        ),
        class: 'links'
      )
    end

    return tag.div(content_fields + content_links, id: attribute_key.to_s) if content_fields

    tag.div(content_links, id: attribute_key.to_s)
  end

  # renders the attachment attribute of the specified form builder using the specified
  # render_info for the model_form partial.
  def render_attachment_model_form(form, attribute_key, attribute_render_info)
    data = attribute_render_info[:data] || {}

    render_active_storage_upload_field(form,
                                       attribute_key,
                                       attribute_render_info,
                                       multiple: false,
                                       max_files: 1,
                                       max_size: data[:max_size] || FILE_UPLOAD_MAX_SIZE,
                                       accept: data[:accept])
  end

  # renders the attachments attribute of the specified form builder using the specified
  # render_info for the model_form partial.
  def render_attachments_model_form(form, attribute_key, attribute_render_info)
    data = attribute_render_info[:data] || {}

    render_active_storage_upload_field(form,
                                       attribute_key,
                                       attribute_render_info,
                                       multiple: true,
                                       max_files: data[:max_files] || MAX_FILES_COUNT,
                                       max_size: data[:max_size] || FILE_UPLOAD_MAX_SIZE,
                                       accept: data[:accept])
  end

  # Renders an image attribute in the specified form builder, holding an active record attachment using
  # the specified render_info for the model_form partial.
  def render_image_model_form(form, attribute_key, attribute_render_info)
    attribute_render_info[:data] = {} unless attribute_render_info[:data]
    attribute_render_info[:data][:accept] = 'image/*'

    render_attachment_model_form(form, attribute_key, attribute_render_info)
  end

  # Renders an multiple images attribute in the specified form builder, holding active record attachments using
  # the specified render_info for the model_form partial.
  def render_images_model_form(form, attribute_key, attribute_render_info)
    attribute_render_info[:data] = {} unless attribute_render_info[:data]
    attribute_render_info[:data][:accept] = 'image/*'

    render_attachments_model_form(form, attribute_key, attribute_render_info)
  end

  # Renders an hidden input  attribute in the specified form builder.
  def render_hidden_model_form(form, attribute_key, _attribute_render_info)
    form.hidden_field attribute_key
  end

  # Renders an enum attribute in the specified form builder.
  def render_enum_model_form(form, attribute_key, attribute_render_info)
    # get enum name
    enum_name = enum_name attribute_key, attribute_render_info

    # get html options and append combobox class for having select2 field
    html_options = html_options_model_form(form, attribute_key, attribute_render_info)
    html_options[:class] = "#{html_options[:class]} combobox"

    # render the field
    form.collection_select attribute_key,
                           form.object.class.send(enum_name.pluralize),
                           :first,
                           lambda { |key|
                             human_enum_name form.object.class.to_s, enum_name, key.first
                           },
                           {},
                           html_options
  end

  # Renders an attribute having the type :collection_select
  # Expects the attribute :data in the attribute_render_info holding the following entries:
  # :items is a set of items that will be shown as selectable list
  # :label_method is the attribute name shown as label for each item.
  def render_collection_select_model_form(form, attribute_key, attribute_render_info)
    tag.p do
      form.collection_check_boxes(
        "#{attribute_key.to_s.singularize}_ids".to_sym,
        attribute_render_info[:data][:items],
        :id,
        attribute_render_info[:data][:label_method] || :id,
        html_options_model_form(form, attribute_key, attribute_render_info)
      ) do |box|
        box.label('data-value': box.value) { box.check_box + ' ' + box.text } + tag.br
      end
    end
  end

  # Renders an attribute having the type :duration.
  # Shows a list of selectable durations. Each of this entry is called a step.
  # Expects the attribute :data in the attribute_render_info holding the following entries:
  # :step_label is a label that is shown for each item in the list holding a step. The default value is minutes.
  # :step_multiplier is an hash holding the values each step is multiplied by to get the resulting duration, this can be
  #   :seconds <- default here is 0
  #   :minutes <- default here is 1
  #   :hours <- default here is 0
  #   :days <- default here is 0
  #   :months <- default here is 0
  #   :years <- default here is 0
  # :min_step is the minimum selectable step. The default value is 1.
  # :max_step is the minimum selectable step. The default value is 10.
  #
  # for instance:
  # {
  #   step_label: "minutes",
  #   step_seconds: { minutes: 1 },
  #   min_step: 1,
  #   max_step: 3
  # }
  #
  # will show a selection of three items, for 1 minute, 2 minute and 3 minute.
  # They will be resolved to 60 seconds, 120 seconds and 180 seconds.
  def render_duration_model_form(form, attribute_key, attribute_render_info)
    render_duration_field(form, attribute_key, attribute_render_info)
  end

  private

  # Builds a duration string normed by ISO 8601 specified by the given values.
  def build_iso_duration_string(years: 0, months: 0, days: 0, hours: 0, minutes: 0, seconds: 0)
    res = 'P'
    res = "#{res}#{years.positive? ? "#{years}Y" : ''}"
    res = "#{res}#{months.positive? ? "#{months}M" : ''}"
    res = "#{res}#{days.positive? ? "#{days}D" : ''}"
    return res if hours.zero? && minutes.zero? && seconds.zero?

    res = "#{res}T"
    res = "#{res}#{hours.positive? ? "#{hours}H" : ''}"
    res = "#{res}#{minutes.positive? ? "#{minutes}M" : ''}"
    "#{res}#{seconds.positive? ? "#{seconds}S" : ''}"
  end

  # Returns the default html_options for some attribute in the model_form
  # partial. If some additional html_options are defined in the given render_info
  # they are added to the result. The given options will be priorizes, due to conflicts.
  def html_options_model_form(form, attribute_key, attribute_render_info)
    js_controller_name = stimulus_controller_name

    # set the default options, including stimulus actions and targets for javascript controller
    default_options = {
      class: "form-control #{'is-invalid' unless form.object.errors[attribute_key].empty?}",
      data: {
        action: "#{js_controller_name}#onChange#{attribute_key.to_s.camelize(:upper)}"
      }
    }
    default_options[:data][:"#{js_controller_name}-target"] = "#{attribute_key.to_s.camelize(:lower)}Field"

    # Set the default value, if available
    if attribute_render_info[:default_value]
      default_options[:value] = attribute_default_value(form, attribute_render_info)
    end

    # merge if html options are given
    return default_options.merge(attribute_render_info[:html_options]) if attribute_render_info[:html_options]

    # return default
    default_options
  end

  # Returns the default id generated by rails form builders for the attributes field
  # in the specified form.
  def id_for(form, attribute_key, _attribute_render_info)
    "#{form.object_name}_#{attribute_key}"
  end

  # Returns the default name generated by rails form builders for the attributes field
  # in the specified form.
  def name_for(form, attribute_key, attribute_render_info)
    # if this is some kind of array. put brackets behind name
    type = attribute_type(form.object.class, attribute_key, attribute_render_info)
    if type == :attachments ||
       type == :images ||
       (type == :association && form.object.send(attribute_key).is_a?(ActiveRecord::Associations::CollectionProxy))
      return "#{form.object_name}[#{attribute_key}][]"
    end

    "#{form.object_name}[#{attribute_key}]"
  end

  # Renders a drop and pastezone component, having the default options except for the given ones.
  # options expects the following options:
  # multiple - boolean
  # max_files - integer or nil
  # max_size - optional - maximum size of a file, if not given,
  #   the constant FILE_UPLOAD_MAX_SIZE will be taken as default
  # accept - string (format of accepted file types, for instance image/png) or nil
  #
  def render_active_storage_upload_field(form, attribute_key, attribute_render_info, options)
    # catch nessecary info for dropzone component to render existing files in edit action
    begin
      # get array for attachment objects, even if only one is attached
      existing_files = form.object.send(attribute_key)
      if existing_files.is_a?(ActiveStorage::Attached::One)
        existing_files = existing_files.attached? ? [existing_files] : []
      end

      # convert each file to data the field needs
      existing_files = existing_files.map do |file|
        res_hash = {
          signed_id: file.signed_id
        }
        res_hash[:preview_image] = url_for(file) if file.content_type.include?('image')
        res_hash[:preview_text] = file.filename unless file.content_type.include?('image')
        res_hash
      end
    rescue Module::DelegationError
      existing_files = []
    end

    # determine max size in bytes for rendering
    max_size = options[:max_size] || FILE_UPLOAD_MAX_SIZE

    render partial: 'ez_on_rails/shared/fields/active_storage_upload_field', locals: {
      max_size_error: t(:'ez_on_rails.fields.active_storage_upload_field.default_max_size_error',
                        max_size_mb: max_size / 1_048_576),
      max_files_error: t(:'ez_on_rails.fields.active_storage_upload_field.default_max_files_error',
                         max_files: options[:max_files]),
      invalid_format_error: t(:'ez_on_rails.fields.active_storage_upload_field.default_invalid_format_error'),
      multiple: options[:multiple],
      max_files: options[:max_files],
      max_size:,
      accept: options[:accept],
      input_name: name_for(form, attribute_key, attribute_render_info),
      input_id: id_for(form, attribute_key, attribute_render_info),
      existing_files:
    }
  end

  # Renders the DurationSelect component.
  def render_duration_field(form, attribute_key, attribute_render_info)
    default_value = form.object.send(attribute_key)
    default_value = default_value.iso8601 if default_value.is_a?(ActiveSupport::Duration)

    max_years = 10
    if attribute_render_info[:data] && attribute_render_info[:data][:max_years]
      max_years = attribute_render_info[:data][:max_years]
    end

    render partial: 'ez_on_rails/shared/fields/duration_field', locals: {
      id: id_for(form, attribute_key, attribute_render_info),
      name: name_for(form, attribute_key, attribute_render_info),
      default_value:,
      max_years:,
      label_years: t(:years),
      label_months: t(:months),
      label_weeks: t(:weeks),
      label_days: t(:days),
      label_hours: t(:hours),
      label_minutes: t(:minutes),
      label_seconds: t(:seconds)
    }
  end

  # Renders a field for selecting some polymorphic association record.
  def render_polymorphic_association_field(form, attribute_key, attribute_render_info)
    # identify the label method for the record selection
    label_method = get_label_method(attribute_render_info)

    # identify the current value
    default_value = form.object.send(attribute_key)

    # create the data needed by the javascript controller, holding labels and record ids etc.
    records_data = {}.tap do |record_data_hash|
      attribute_render_info[:data].each do |key, value|
        record_type_class = Class.const_get key.to_s.singularize.camelize
        record_type_string = record_type_class.to_s

        # the type is the key here, this makes it easy to access the data in the javscript
        record_data_hash[record_type_string] = {}

        # get the translated label for the record type
        record_data_hash[record_type_string][:type_label] = record_type_class.model_name.human

        # get the records that should be selectable
        record_data_hash[record_type_string][:records] = value.map do |record|
          { id: record.id, label: record.send(label_method) }
        end
      end
    end

    # indicate whether this is an optional relation
    relation_reflection = form.object.class.reflect_on_association(attribute_key)
    nullable = if relation_reflection.options.key?(:optional)
                 relation_reflection.options[:optional]
               elsif relation_reflection.options.key?(:required)
                 !relation_reflection.options[:required]
               else
                 false
               end

    render partial: 'ez_on_rails/shared/fields/polymorphic_association_field', locals: {
      # base_id is extended by _id and _type in the view
      base_id: id_for(form, attribute_key, attribute_render_info),
      # base_name is changed to type and id in the view
      base_name: name_for(form, attribute_key, attribute_render_info),
      records_data:,
      default_value_type: default_value&.class&.to_s,
      default_value_id: default_value&.id,
      nullable:
    }
  end
end
