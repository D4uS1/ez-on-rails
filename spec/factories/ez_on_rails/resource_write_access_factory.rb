# frozen_string_literal: true

FactoryBot.define do
  factory :eor_resource_write_access, class: 'EzOnRails::ResourceWriteAccess' do
    group factory: :or_group
    resource factory: :user_owned_record
  end
end
