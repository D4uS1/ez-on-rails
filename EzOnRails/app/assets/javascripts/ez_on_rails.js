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

// load this first, because some scripts may use jquery
import $ from "jquery"

// javascript to own field components
// This needs to be imported first, because there is a fix for select2 in this file that needs
// to be loaded before the select2 import occurs
import "ez_on_rails/controllers"

import "@hotwired/turbo-rails"
import "bootstrap"
import "select2"
import "@nathanvda/cocoon"
import "@fortawesome/fontawesome-free"
import * as ActiveStorage from "@rails/activestorage"

// from own scripts
import "ez_on_rails/shared/_enhanced_table"
import "ez_on_rails/shared/_flash_messages"
import "ez_on_rails/shared/_model_form"

// initializers
ActiveStorage.start();

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


