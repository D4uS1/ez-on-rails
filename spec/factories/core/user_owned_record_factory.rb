# frozen_string_literal: true

FactoryBot.define do
  factory :user_owned_record, class: 'UserOwnedRecord' do
    factory :user_owned_record_without_validation do
      to_create { |instance| instance.save(validate: false) }
    end
  end
end
