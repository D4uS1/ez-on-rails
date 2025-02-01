# frozen_string_literal: true

FactoryBot.define do
  factory :nested_form_test, class: 'NestedFormTest' do
    test_string { 'test string' }
    test_int { 1 }
    test_bool { true }
    parent_form_test
  end
end
