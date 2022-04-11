require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

require "jquery"
require "bootstrap"
require "select2"
require "data-confirm-modal"
require "cocoon"
axios = require 'axios'

import "@fortawesome/fontawesome-free/js/all";
import "shared/_enhanced_table"
import "shared/_flash_messages"
import "shared/_model_form"

# Support component names relative to this directory:
componentRequireContext = require.context('components', true)
ReactRailsUJS = require('react_ujs')
ReactRailsUJS.useContext(componentRequireContext)

# get sure that every ajax requests uses the authenticity token
axios.defaults.headers.common['X-CSRF-Token'] = document.querySelector('meta[name=csrf-token]').content

# set an indicator if some ajax request is running, especially used for capybara tests wo wait for
# finishing ajax requests
$ ->
  window.ajaxRunning = false
  $(document).ajaxStart ->
    window.ajaxRunning = true
  $(document).ajaxStop ->
    window.ajaxRunning = false

# The function to call on document ready.
# Need to wrap this into an extra function because if you need this function not to load in turbolinks
# page:load event for some readson, you can use it.
onDocumentReady = ->
  # always pass csrf tokens on ajax calls
  $.ajaxSetup({
    headers: { 'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content') }
  })

  # react components need to be mounted in nested forms
  $(document).on 'cocoon:after-insert', (e, insertedItem, originalEvent) ->
    itemNode = insertedItem.get()[0];
    return if (!itemNode)
    ReactRailsUJS.mountComponents(itemNode)

# The turbolinks ready handler for page load.
$(document).on 'turbolinks:load', onDocumentReady