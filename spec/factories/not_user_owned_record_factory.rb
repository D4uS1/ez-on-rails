# frozen_string_literal: true

FactoryBot.define do
  factory :not_user_owned_record, class: 'NotUserOwnedRecord' do
    test { 'some string' }
  end
end
