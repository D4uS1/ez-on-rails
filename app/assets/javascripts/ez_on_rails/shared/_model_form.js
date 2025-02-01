import $ from 'jquery'

/**
 * The function to call on document ready.
 * Need to wrap this into an extra function because if you need this function not to load in turbolinks
 * page:load event for some reason, you can use it.
 */
const onDocumentReady = () => {
  /**
   * select2 class binding
   */
  $('.combobox').each(function () {
    // Should this select2 field be able to add options dynamically?
    const hasTags = $(this).hasClass('taggable');

    // Create the select2 field
    const dropdownParent = $(this).parents('.modal').length > 0 ? $(this).closest('.modal') : $(document.body);
    return $(this).select2({
      theme: 'bootstrap-5',
      dropdownParent: dropdownParent,
      tags: hasTags
    });
  });

  /**
   * Fires native javascript events if the select2 selection changed.
   * This is necessary because select2 uses its own event framework.
   * Without this, stimulus onChange actions on select2 fields will not be called.
   * See https://psmy.medium.com/rails-6-stimulus-and-select2-de4a4d2b59e4 for details.
   */
  $(".combobox").on('select2:select', function () {
    let event = new Event('change', { bubbles: true })
    this.dispatchEvent(event);
  });
};

// The turbolinks ready handler for page load.
$(document).on('turbo:load', onDocumentReady);

// this is needed for eg form submission, because tubo:load will not trigger here.
$(document).on('turbo:render', onDocumentReady);
