//= link_tree ../images
//= link_directory ../stylesheets .css
//= link ez_on_rails_manifest.js

// This was added to prevent an console error to occur.
// Rails seems to auto-include an import "application" script, even if it was not asked...
// Hence we need to provide some application.js to prevent the console from showing an
// error that application.js could not be found.
//= link application.js
