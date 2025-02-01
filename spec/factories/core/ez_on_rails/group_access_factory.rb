# frozen_string_literal: true

FactoryBot.define do
  factory :eor_group_access, class: 'EzOnRails::GroupAccess' do
    group factory: :or_group
    namespace { 'api' }
  end
end
