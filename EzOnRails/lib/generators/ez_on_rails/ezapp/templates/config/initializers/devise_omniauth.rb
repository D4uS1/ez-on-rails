# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  #  provider :gitlab,
  #           Rails.application.credentials.omniauth[:gitlab][:uid],
  #           Rails.application.credentials.omniauth[:gitlab][:secret],
  #           scope: 'read_user'
  # provider :email,
  #          Rails.application.credentials.omniauth[:email][:uid],
  #          Rails.application.credentials.omniauth[:email][:secret],
  #          scope: 'profile email'
end
