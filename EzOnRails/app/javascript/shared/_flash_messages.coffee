onDocumentReady = ->
  timeout = $('#flash-message-container').data('auto-dismiss')
  setTimeout(() ->
    $("[name='flash-message']").alert('close')
  , timeout)

# The turbolinks ready handler for page load.
$(document).on 'turbolinks:load', onDocumentReady
