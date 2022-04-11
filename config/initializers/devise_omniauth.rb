# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :email,
           Rails.application.credentials.omniauth[:email][:uid],
           Rails.application.credentials.omniauth[:email][:secret],
           scope: 'profile email'
end