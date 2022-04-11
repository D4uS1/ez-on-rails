# frozen_string_literal: true

## Be sure to restart your server when you modify this file.
## Avoid CORS issues when API is called from the frontend app.
## Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.
## Read more: https://github.com/cyu/rack-cors
# Rails.application.config.middleware.insert_before 0, Rack::Cors do
#   if Rails.env.development?
#     allow do
#       origins 'http://localhost:3001'
#       resource '*',
#                headers: :any,
#                methods: %i[get post patch put delete],
#                expose: %w[Access-Token Uid Client Expiry Token-Type]
#     end
#
#     next
#   end
#
#   # Configure CORS for other environments
#   # allow do
#   #   origins 'PUT YOUR CLIENT APP URL HERE'
#   #   resource '*',
#   #            headers: :any,
#   #            methods: %i[get post patch put delete],
#   #            expose: %w[Access-Token Uid Client Expiry Token-Type]
#   # end
# end
