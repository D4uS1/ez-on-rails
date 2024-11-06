# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: 'User' do
    username { Faker::Name.unique.name }
    email { Faker::Internet.unique.email }
    password { 'password' }
    confirmed_at { DateTime.now }
    privacy_policy_accepted { true }

    # Test users
    factory :andrew do
      username { 'Andrew' }
      email { 'andrew.duesenaw@ez.de' }
      password { 'andrewandrew' }
      confirmed_at { DateTime.now }
      privacy_policy_accepted { true }
    end

    factory :john do
      username { 'John' }
      email { 'johan.churcher@ez.com' }
      password { 'johnjohn' }
      confirmed_at { DateTime.now }
      privacy_policy_accepted { true }
    end

    factory :bob do
      username { 'Bob' }
      email { 'low.bob@ez.com' }
      password { 'lowbob' }
      confirmed_at { DateTime.now }
      privacy_policy_accepted { true }
    end

    factory :christoph do
      username { 'Christoph' }
      email { 'christoph@ez.com' }
      password { 'christophspw' }
      confirmed_at { DateTime.now }
      privacy_policy_accepted { true }
    end

    factory :florian do
      username { 'Florian' }
      email { 'florian@ez.com' }
      password { 'florianspw' }
      confirmed_at { DateTime.now }
      privacy_policy_accepted { true }
    end
  end
end
