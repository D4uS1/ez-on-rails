# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EzOnRails::SearchFilterParser do
  context 'when calling parse' do
    it 'returns nil for empty value' do
      expect(described_class.parse(nil)).to be_nil
    end

    it 'parses for given filter_descriptor' do
      value = {
        field: 'name',
        operator: 'contains',
        value: 'value'
      }

      expected_result = '(name ~ "value")'

      expect(described_class.parse(value)).to eq(expected_result)
    end

    it 'parses for given filter_composite_descriptor' do
      value = {
        logic: 'and',
        filters: [{
          field: 'name',
          operator: 'eq',
          value: 'value'
        },
                  {
                    field: 'customers',
                    operator: 'gt',
                    value: 0
                  }]
      }

      expected_result = '((name = "value") and (customers > 0))'

      expect(described_class.parse(value)).to eq(expected_result)
    end

    it 'maps operators' do
      value = {
        field: 'name',
        operator: 'neq',
        value: 'value'
      }

      expected_result = '(name != "value")'

      expect(described_class.parse(value)).to eq(expected_result)
    end

    it 'surrounds strings with quotes' do
      value = {
        field: 'name',
        operator: 'eq',
        value: 'value'
      }

      expected_result = '(name = "value")'

      expect(described_class.parse(value)).to eq(expected_result)
    end

    it 'does not surround value with strings for numbers' do
      value = {
        field: 'happiness',
        operator: 'gte',
        value: 100
      }

      expected_result = '(happiness >= 100)'

      expect(described_class.parse(value)).to eq(expected_result)
    end

    it 'does not surround value with strings for booleans' do
      value = {
        field: 'happy',
        operator: 'eq',
        value: true
      }

      expected_result = '(happy = true)'

      expect(described_class.parse(value)).to eq(expected_result)
    end

    it 'parses correct for nested filter_composite_descriptor' do
      value = {
        logic: 'and',
        filters: [{
          logic: 'or',
          filters: [
            {
              field: 'happy',
              operator: 'eq',
              value: true
            },
            {
              field: 'happiness',
              operator: 'gte',
              value: 100
            }
          ]
        },
                  {
                    field: 'customers',
                    operator: 'gt',
                    value: 0
                  }]
      }

      expected_result = '(((happy = true) or (happiness >= 100)) and (customers > 0))'

      expect(described_class.parse(value)).to eq(expected_result)
    end

    it 'parses correct for null check' do
      value = {
        field: 'name',
        operator: 'isnull',
        value: nil
      }

      expected_result = '(null? name)'

      expect(described_class.parse(value)).to eq(expected_result)
    end

    it 'parses correct for empty check' do
      value = {
        field: 'name',
        operator: 'isempty',
        value: nil
      }

      expected_result = '(set? name)'

      expect(described_class.parse(value)).to eq(expected_result)
    end

    it 'converts keys to snake_case' do
      value = {
        field: 'companyName',
        operator: 'eq',
        value: 'Metro'
      }

      expected_result = '(company_name = "Metro")'

      expect(described_class.parse(value)).to eq(expected_result)
    end

    it 'does not convert values to snake_case' do
      value = {
        field: 'companyName',
        operator: 'eq',
        value: 'value'
      }

      expected_result = '(company_name = "value")'

      expect(described_class.parse(value)).to eq(expected_result)
    end
  end
end
