# frozen_string_literal: true

FactoryBot.define do
  factory :eor_user_group_assignment, class: 'EzOnRails::UserGroupAssignment' do
    user factory: :user
    group factory: :eor_group
  end
end
