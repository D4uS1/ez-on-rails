# frozen_string_literal: true

FactoryBot.define do
  factory :sharable_resource, class: 'SharableResource' do
    test { 'Testvalue' }
  end
end
