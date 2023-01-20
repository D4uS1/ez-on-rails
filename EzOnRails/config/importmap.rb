pin "ez_on_rails"
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "bootstrap", to: "https://ga.jspm.io/npm:bootstrap@5.2.3/dist/js/bootstrap.esm.js"
pin "@popperjs/core", to: "https://ga.jspm.io/npm:@popperjs/core@2.11.6/lib/index.js"
pin "select2", to: "https://ga.jspm.io/npm:select2@4.1.0-rc.0/dist/js/select2.js"
pin "jquery", to: "https://ga.jspm.io/npm:jquery@3.6.3/dist/jquery.js"
pin "cocoon", to: "https://ga.jspm.io/npm:cocoon@0.1.1/lib/index.js"
pin "@rails/activestorage", to: "https://ga.jspm.io/npm:@rails/activestorage@7.0.4/app/assets/javascripts/activestorage.esm.js"
pin "react-dropzone", to: "https://ga.jspm.io/npm:react-dropzone@14.2.3/dist/es/index.js"
pin "attr-accept", to: "https://ga.jspm.io/npm:attr-accept@2.2.2/dist/index.js"
pin "file-selector", to: "https://ga.jspm.io/npm:file-selector@0.6.0/dist/es5/index.js"
pin "prop-types", to: "https://ga.jspm.io/npm:prop-types@15.8.1/index.js"
pin "react", to: "https://ga.jspm.io/npm:react@18.2.0/index.js"
pin "tslib", to: "https://ga.jspm.io/npm:tslib@2.4.1/tslib.es6.js"
pin_all_from File.expand_path("../app/assets/javascripts", __dir__)


