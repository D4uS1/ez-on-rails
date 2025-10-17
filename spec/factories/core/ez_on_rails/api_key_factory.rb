# frozen_string_literal: true

FactoryBot.define do
  factory :eor_api_key, class: 'EzOnRails::ApiKey' do
    api_key { Faker::Alphanumeric.unique }
    expires_at { 2.days.since }
  end
end
