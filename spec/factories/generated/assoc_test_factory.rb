# frozen_string_literal: true

FactoryBot.define do
  factory :assoc_test, class: 'AssocTest' do
    bearer_token_access_test
    parent_form_test
  end
end
