# frozen_string_literal: true

FactoryBot.define do
  factory :eor_resource_destroy_access, class: 'EzOnRails::ResourceDestroyAccess' do
    group factory: :or_group
    resource factory: :user_owned_record
  end
end
