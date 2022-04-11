# frozen_string_literal: true

FactoryBot.define do
  factory :validation_error_test, class: 'ValidationErrorTest' do
    name { 'test name' }
    number { 1 }
  end
end
