# frozen_string_literal: true

pin 'ez_on_rails'
pin_all_from File.expand_path('../app/assets/javascripts', __dir__)
pin '@hotwired/turbo', to: 'https://ga.jspm.io/npm:@hotwired/turbo@8.0.12/dist/turbo.es2017-esm.js'
pin '@rails/actioncable/src', to: 'https://ga.jspm.io/npm:@rails/actioncable@7.2.201/src/index.js'
pin '@hotwired/turbo-rails', to: 'https://ga.jspm.io/npm:@hotwired/turbo-rails@8.0.12/app/javascript/turbo/index.js'
pin '@hotwired/stimulus', to: 'stimulus.min.js', preload: true
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js', preload: true
pin 'jquery', to: 'https://ga.jspm.io/npm:jquery@3.6.3/dist/jquery.js', preload: true
pin 'bootstrap', to: 'https://ga.jspm.io/npm:bootstrap@5.2.3/dist/js/bootstrap.esm.js'
pin '@popperjs/core', to: 'https://ga.jspm.io/npm:@popperjs/core@2.11.6/lib/index.js'
pin 'select2', to: 'https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js', preload: true
pin '@nathanvda/cocoon', to: 'https://ga.jspm.io/npm:@nathanvda/cocoon@1.2.14/cocoon.js'
pin '@rails/activestorage', to: 'https://ga.jspm.io/npm:@rails/activestorage@7.0.4/app/assets/javascripts/activestorage.esm.js'
pin '@fortawesome/fontawesome-free', to: 'https://ga.jspm.io/npm:@fortawesome/fontawesome-free@6.2.1/js/all.js'
pin '@rails/ujs', to: 'https://ga.jspm.io/npm:@rails/ujs@7.0.6/lib/assets/compiled/rails-ujs.js'
