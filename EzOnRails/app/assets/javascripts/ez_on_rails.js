//= link ez_on_rails/shared/_enhanced_table.js
//= link ez_on_rails/shared/_flash_messages.js
//= link ez_on_rails/shared/_model_form.js
//= link ez_on_rails/components/ActiveStorageDropzone.tsx
//= link ez_on_rails/components/DurationSelect.tsx

// This is a nasty hack because popper (dependency of bootstrap) tries to access a process variable,
// but since we are not in a node environment (because rails 7 provides importmaps), we dont have a process variable.
window.process = {
  env: {
    NODE_ENV: 'production'
  }
}

// from external resources
import $ from 'jquery'
import "@hotwired/turbo-rails"
import "bootstrap"
import "select2"
import "cocoon"
import * as ActiveStorage from "@rails/activestorage"

// from own scripts
import "ez_on_rails/shared/_enhanced_table"
import "ez_on_rails/shared/_flash_messages"
import "ez_on_rails/shared/_model_form"

// initializers
ActiveStorage.start();

// Support component names relative to this directory:
/*
const componentRequireContext = require.context('components', true);
const ReactRailsUJS = require('react_ujs');
ReactRailsUJS.useContext(componentRequireContext);
*/

/**
 * set an indicator if some ajax request is running, especially used for capybara tests wo wait for
 * finishing ajax requests
 */
$(() => {
  window.ajaxRunning = false;
  $(document).ajaxStart(() => {
    window.ajaxRunning = true;
  });

  $(document).ajaxStop(() => {
    window.ajaxRunning = false;
  });
});

/**
 * The function to call on document ready.
 * Need to wrap this into an extra function because if you need this function not to load in turbolinks
 * page:load event for some readson, you can use it.
 */
const onDocumentReady = () => {
  // always pass csrf tokens on ajax calls
  $.ajaxSetup({
    headers: {
      'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    }
  });

  //react components need to be mounted in nested forms
  $(document).on('cocoon:after-insert', (e, insertedItem, originalEvent) => {
    const itemNode = insertedItem.get()[0];
    if (!itemNode) return;

    ReactRailsUJS.mountComponents(itemNode);
  });
};

// The turbolinks ready handler for page load.
$(document).on('turbo:load', onDocumentReady);


