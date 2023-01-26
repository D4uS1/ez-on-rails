# frozen_string_literal: true

pin 'ez_on_rails'
pin '@hotwired/turbo-rails', to: 'turbo.min.js', preload: true
pin '@hotwired/stimulus', to: 'stimulus.min.js', preload: true
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js', preload: true
pin 'bootstrap', to: 'https://ga.jspm.io/npm:bootstrap@5.2.3/dist/js/bootstrap.esm.js'
pin '@popperjs/core', to: 'https://ga.jspm.io/npm:@popperjs/core@2.11.6/lib/index.js'
pin 'select2', to: 'https://ga.jspm.io/npm:select2@4.1.0-rc.0/dist/js/select2.js'
pin 'jquery', to: 'https://ga.jspm.io/npm:jquery@3.6.3/dist/jquery.js'
pin 'cocoon', to: 'https://ga.jspm.io/npm:cocoon@0.1.1/lib/index.js'
pin '@rails/activestorage', to: 'https://ga.jspm.io/npm:@rails/activestorage@7.0.4/app/assets/javascripts/activestorage.esm.js'
pin '@fortawesome/fontawesome-free', to: 'https://ga.jspm.io/npm:@fortawesome/fontawesome-free@6.2.1/js/all.js'
pin_all_from File.expand_path('../app/assets/javascripts', __dir__)
