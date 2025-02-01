# frozen_string_literal: true

FactoryBot.define do
  factory :properties_test, class: 'PropertiesTest' do
    string_value { 'Ducimus aspernatur occaecati eos.' }
    integer_value { 1 }
    float_value { 1.0 }
    date_value { '2021-12-17' }
    datetime_value { '2021-12-17 11:44:23 UTC' }
    boolean_value { true }

    assoc_test
  end
end
