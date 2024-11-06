import { Application } from "@hotwired/stimulus"

// This is needed because select2 references jquery
// It is important to have this before the import of select2 happens
import jQuery from "jquery"
window.jQuery = jQuery
window.$ = jQuery

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
