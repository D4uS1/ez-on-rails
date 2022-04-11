# frozen_string_literal: true

FactoryBot.define do
  factory :eor_group, class: 'EzOnRails::Group' do
    # factory for non validated groups
    factory :eor_group_without_validation do
      to_create { |instance| instance.save(validate: false) }
    end

    factory :testgroup do
      name { 'Testgroup' }
    end
  end
end
