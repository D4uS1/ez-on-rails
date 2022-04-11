# frozen_string_literal: true

FactoryBot.define do
  factory :eor_ownership_info, class: 'EzOnRails::OwnershipInfo' do
    resource { 'EzOnRails::Group' }
  end
end
