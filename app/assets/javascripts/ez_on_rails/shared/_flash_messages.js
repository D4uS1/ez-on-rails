import $ from 'jquery'
import * as bootstrap from 'bootstrap'

/**
 * The function to call on document ready.
 * Need to wrap this into an extra function because if you need this function not to load in turbolinks
 * page:load event for some reason, you can use it.
 */
const onDocumentReady = () => {
  const timeout = $('#flash-message-container').data('auto-dismiss')
  setTimeout(() => {
      $(".alert").each(function () {
          const alert = new bootstrap.Alert(this);
          alert.close();
      })
  }, timeout);
};


// The turbolinks ready handler for page load.
$(document).on('turbo:load', onDocumentReady)
