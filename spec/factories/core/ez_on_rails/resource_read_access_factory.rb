# frozen_string_literal: true

FactoryBot.define do
  factory :eor_resource_read_access, class: 'EzOnRails::ResourceReadAccess' do
    group factory: :or_group
    resource factory: :user_owned_record
  end
end
