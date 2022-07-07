# frozen_string_literal: true

FactoryBot.define do
  factory :eor_ownership_info, class: 'EzOnRails::OwnershipInfo' do
    ownerships { true }
    resource { 'EzOnRails::Group' }
  end
end
