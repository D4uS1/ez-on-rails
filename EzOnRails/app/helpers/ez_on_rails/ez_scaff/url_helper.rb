# frozen_string_literal: true

# Contains helper methods for getting object url paths and
# renderering links and buttons targeting to that links.
module EzOnRails::EzScaff::UrlHelper
  # Searches for a post_url in the given locals. If no post_url was found,
  # the post_url of the given resource object obj will be returned.
  def get_post_url(obj, locals)
    locals[:post_url] || url_for(obj)
  end

  # Returns the name of the save link in a edit or new resource.
  # If the locals contains the label, this will be returned.
  # Returns the default otherwise.
  def label_save_link(locals)
    locals[:save_label] || t(:'ez_on_rails.save')
  end

  # Returns the name of the submit link in a form.
  # If the locals contains the label, this will be returned.
  # Returns the default otherwise.
  def label_submit_link(locals)
    locals[:submit_label] || t(:'ez_on_rails.submit')
  end

  # Returns the name of the search link in a search_form.
  # If the locals contains the label, this will be returned.
  # Returns the default otherwise.
  def label_search_link(locals)
    locals[:search_label] || t(:'ez_on_rails.search')
  end

  # Returns the name of the destroy link to a resource.
  # If the locals contains the label, this will be returned.
  # Returns the default otherwise.
  def label_back_link(locals)
    return locals[:print_back][:label] if locals[:print_back].is_a?(Hash) && locals[:print_back]&.dig(:label)

    t(:'ez_on_rails.back')
  end

  # Renders a back link.
  # If the given locals contain a back link label, the link will be named with that label.
  # Otherwise the default name will be taken.
  def render_back_link(locals)
    link_to label_back_link(locals), :back, class: 'text-secondary'
  end

  # Renders an back button.
  # If the given locals contain a back button label, the button will be named like this.
  # Otherwise the label will be named with the default value.
  def render_back_button(locals)
    link_to icon_with_text('chevron-left', label_back_link(locals)),
            :back,
            class: 'btn btn-secondary'
  end

  # Searches for a index_url in the given locals. If no index_url was found,
  # the index_url of the given resource object obj will be returned.
  def get_index_url(obj, locals)
    locals[:index_url] || url_for(obj.class)
  end

  # Searches for a search_url in the given locals. If no search_url was found,
  # the search_url of the given resource object class will be returned.
  def get_search_url(obj_class, locals)
    locals[:search_url] || "#{url_for(obj_class)}/search"
  end

  # Returns the name of the index link to a resource.
  # If the locals contains the label, this will be returned.
  # Otherwise the link will return the pluralized human readable name of the resource.
  def label_index_link(obj, locals)
    return locals[:print_index][:label] if locals[:print_index].is_a?(Hash) && locals[:print_index]&.dig(:label)

    obj.class.model_name.human(count: 2)
  end

  # returns wether the index link should be printed depending on the information given by the
  # local variables passed to the view from the controller.
  # Since the helper are not able to access the locals of the view, they have to be passed as parameters.
  def render_index_link?(obj, locals)
    (locals[:print_index] || locals[:print_controls]) && access_to_url?(get_index_url(obj, locals))
  end

  # Renders an index link for the specified application record object.
  # If the given locals contain a index_link, the button will target to that link.
  # Otherwise the link will be determined by the given resource object.
  def render_index_link(obj, locals)
    link_to label_index_link(obj, locals),
            get_index_url(obj, locals), class: 'text-secondary'
  end

  # Renders an index link for the specified application record object.
  # If the given locals contain a index_link, the button will target to that link.
  # Otherwise the link will be determined by the given resource object.
  def render_index_button(obj, locals)
    link_to icon_with_text('list', label_index_link(obj, locals)),
            get_index_url(obj, locals),
            class: 'btn btn-secondary'
  end

  # Searches for a show_url in the given locals. If no show_url was found,
  # the show_url of the given resource object obj will be returned.
  # If the local :show_url exists and is a proc, the proc will be executed by passing
  # the obj as argument. Otherweise the value of :show_url will be taken directly.
  def get_show_url(obj, locals)
    show_url = locals[:show_url]
    return show_url.call(obj) if show_url.is_a?(Proc)
    return show_url if show_url

    url_for(obj)
  end

  # Returns the name of the show link to a resource.
  # If the locals contains the label, this will be returned.
  # Returns the default otherwise.
  def label_show_link(locals)
    return locals[:print_show][:label] if locals[:print_show].is_a?(Hash) && locals[:print_show]&.dig(:label)

    t(:'ez_on_rails.show')
  end

  # returns wether the show link should be printed depending on the information given by the
  # local variables passed to the view from the controller.
  # Since the helper are not able to access the locals of the view, they have to be passed as parameters.
  def render_show_link?(obj, locals)
    access_to_show_resource?(obj) if locals[:print_show] || locals[:print_controls]
  end

  # Renders an show link for the specified application record object.
  # If the given locals contain a show_link, the button will target to that link.
  # Otherwise the link will be determined by the given resource object.
  # If only_icon: true is set, only the icon will be rendered instead of the text label.
  # This can usually for instance be used in tables.
  def render_show_link(obj, locals, only_icon: false)
    link_to only_icon ? ez_icon('eye', class: 'text-dark') : label_show_link(locals),
            get_show_url(obj, locals), class: 'text-secondary'
  end

  # Renders an show link for the specified application record object.
  # If the given locals contain a show_link, the button will target to that link.
  # Otherwise the link will be determined by the given resource object.
  def render_show_button(obj, locals)
    link_to label_show_link(locals),
            get_show_url(obj, locals), class: 'btn btn-info'
  end

  # Returns the url to a new resource for the current controller.
  # If the new_url is specified in the given locals, this link will be returned otherwise.
  def get_new_url(locals)
    locals[:new_url] || "/#{controller_path}/new"
  end

  # Returns wether the new link should be printed depending on the information given by the
  # local variables passed to the view from the controller.
  # Since the helper are not able to access the locals of the view, they have to be passed in here.
  def render_new_link?(locals)
    locals[:print_new] && access_to_url?(get_new_url(locals))
  end

  # Returns the name of the new link to a resource.
  # If the locals contains the label, this will be returned.
  # Returns the default otherwise.
  def label_new_link(locals)
    return locals[:print_new][:label] if locals[:print_new].is_a?(Hash) && locals[:print_new]&.dig(:label)

    t(:'ez_on_rails.add')
  end

  # Returns wether the back link should be printed depending on the information given by the
  # local variables passed to the view from the controller.
  # Since the helper are not able to access the locals of the view, they have to be passed in here.
  def render_back_link?(locals)
    locals[:print_back]
  end

  # Renders the link to a new resource item of the current controller.
  # If the given locals contain a new_link, the button will target to that link.
  # Otherwise the link will be determined by the controller resource.
  def render_new_link(locals)
    link_to label_new_link(locals),
            get_new_url(locals), class: 'text-secondary'
  end

  # Renders the new button for the current controllers resource.
  # If the given locals contains a new_link, the button will target to that link.
  # Otherwise the link will be determined by the current controller.
  def render_new_button(locals)
    link_to icon_with_text('plus', label_new_link(locals)),
            get_new_url(locals),
            class: 'btn btn-success'
  end

  # Searches for a edit_url in the given locals. If no edit_url was found,
  # the edit_url of the given resource object obj will be returned.
  # If the local :edit_url exists and is a proc, the proc will be executed by passing
  # the obj as argument. Otherweise the value of :edit_url will be taken directly.
  def get_edit_url(obj, locals)
    edit_url = locals[:edit_url]
    return edit_url.call(obj) if edit_url.is_a?(Proc)
    return edit_url if edit_url

    "#{url_for(obj)}/edit"
  end

  # Returns the name of the edit link to a resource.
  # If the locals contains the label, this will be returned.
  # Returns the default otherwise.
  def label_edit_link(locals)
    return locals[:print_edit][:label] if locals[:print_edit].is_a?(Hash) && locals[:print_edit]&.dig(:label)

    t(:'ez_on_rails.edit')
  end

  # returns wether the edit link should be printed depending on the information given by the
  # local variables passed to the view from the controller.
  # Since the helper are not able to access the locals of the view, they have to be passed as parameters.
  def render_edit_link?(obj, locals)
    access_to_edit_resource?(obj) if locals[:print_edit] || locals[:print_controls]
  end

  # Renders an edit link for the specified application record object.
  # If the given locals contain a edit_link, the button will target to that link.
  # Otherwise the link will be determined by the given resource object.
  # If only_icon: true is set, only the icon will be rendered instead of the text label.
  # This can usually for instance be used in tables.
  def render_edit_link(obj, locals, only_icon: false)
    link_to only_icon ? ez_icon('edit', class: 'text-primary') : label_edit_link(locals),
            get_edit_url(obj, locals), class: 'text-secondary'
  end

  # Renders an edit link for the specified application record object.
  # If the given locals contain a edit_link, the button will target to that link.
  # Otherwise the link will be determined by the given resource object.
  def render_edit_button(obj, locals)
    link_to icon_with_text('edit', label_edit_link(locals)),
            get_edit_url(obj, locals), class: 'btn btn-primary'
  end

  # Searches for a destroy_url in the given locals. If no destroy_url was found,
  # the destroy_url of the given resource object obj will be returned.
  # If the local :destroy_url exists and is a proc, the proc will be executed by passing
  # the obj as argument. Otherweise the value of :destroy_url will be taken directly.
  def get_destroy_url(obj, locals)
    destroy_url = locals[:destroy_url]
    return destroy_url.call(obj) if destroy_url.is_a?(Proc)
    return destroy_url if destroy_url

    # search_params are passed in _index partial to _enhanced_table partial to enable
    # keeping search results after destroying a single object
    search_url_for(obj, locals[:search_params])
  end

  # Returns the name of the destroy link to a resource.
  # If the locals contains the label, this will be returned.
  # Returns the default otherwise.
  def label_destroy_link(locals)
    return locals[:print_destroy][:label] if locals[:print_destroy].is_a?(Hash) && locals[:print_destroy]&.dig(:label)

    t(:'ez_on_rails.destroy')
  end

  # returns wether the destroy link should be printed depending on the information given by the
  # local variables passed to the view from the controller.
  # Since the helper are not able to access the locals of the view, they have to be passed as parameters.
  def render_destroy_link?(obj, locals)
    access_to_destroy_resource?(obj) if locals[:print_destroy] || locals[:print_controls]
  end

  # Renders an destroy link for the specified application record object.
  # If the given locals contain a destroy_link, the button will target to that link.
  # Otherwise the link will be determined by the given resource object.
  # If only_icon: true is set, only the icon will be rendered instead of the text label.
  # This can usually for instance be used in tables.
  def render_destroy_link(obj, locals, only_icon: false)
    link_to only_icon ? ez_icon('trash', class: 'text-danger') : label_destroy_link(locals),
            get_destroy_url(obj, locals),
            data: { turbo_method: :delete }.merge(confirm_data),
            class: 'text-secondary'
  end

  # Renders an destroy link for the specified application record object.
  # If the given locals contain a destroy_link, the button will target to that link.
  # Otherwise the link will be determined by the given resource object.
  def render_destroy_button(obj, locals)
    link_to icon_with_text('trash', label_destroy_link(locals)),
            get_destroy_url(obj, locals),
            data: { turbo_method: :delete }.merge(confirm_data),
            class: 'btn btn-danger'
  end

  # Returns a hash containing the information for some default confirmation message.
  # The result of this function can be passed to some rails helpers data option to get some confirmation dialog.
  # The given options hash can contain the following values:
  # :message - the shown message of the cofnirmation dialog
  # If some of that data is not passed, the default values will be taken.
  # Hence this method is also callable without any parameters to get some reasonable default confirm message.
  def confirm_data(options = {})
    {
      turbo_confirm: options[:message] || t(:'ez_on_rails.are_you_sure')
    }
  end

  # Returns the url recognized via url_for, including the current search parameters, if given.
  # The search parameters are only appended if the target is given as hash.
  def search_url_for(target, search_params)
    return nil unless target

    return url_for(target.merge({ params: { q: search_params } })) if target.is_a?(Hash)

    polymorphic_path(target, q: search_params)
  end
end
