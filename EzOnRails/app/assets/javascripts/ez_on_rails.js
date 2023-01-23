//= link ez_on_rails/shared/_enhanced_table.js
//= link ez_on_rails/shared/_flash_messages.js
//= link ez_on_rails/shared/_model_form.js
//= link_directory ./ez_on_rails/controllers

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

// javascript to own field components
import "ez_on_rails/controllers"

// initializers
ActiveStorage.start();

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
};

// The turbolinks ready handler for page load.
$(document).on('turbo:load', onDocumentReady);


