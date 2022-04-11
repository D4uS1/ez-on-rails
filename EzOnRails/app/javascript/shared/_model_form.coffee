# The function to call on document ready.
# Need to wrap this into an extra function because if you need this function not to load in turbolinks
# page:load event for some readson, you can use it.
onDocumentReady = ->
  # select2 class binding
  $('.combobox').each (i) ->
    # Should this select2 field be able to add options dynamicly?
    hasTags = $(this).hasClass('taggable')

    # Create the select2 field
    dropdownParent = if $(this).parents('.modal').length > 0 then $(this).closest('.modal') else $(document.body)
    $(this).select2(
      theme: 'bootstrap-5',
      dropdownParent: dropdownParent,
      tags: hasTags
    )



  # select2 class binding
  $('.combobox').each ->


# The turbolinks ready handler for page load.
$(document).on 'turbolinks:load', onDocumentReady