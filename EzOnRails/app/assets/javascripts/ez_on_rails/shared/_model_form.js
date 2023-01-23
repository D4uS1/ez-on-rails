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
};

// The turbolinks ready handler for page load.
$(document).on('turbo:load', onDocumentReady);
