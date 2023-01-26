# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JsonSchemaValidatorTest do
  let(:valid_attributes) { attributes_for(:andrew).merge({ password: 'testpassword' }) }

  context 'when validating' do
    context 'when passing no path to the validator' do
      it 'accepts valid record' do
        expect(
          described_class.create(test: { 'nullable_string' => nil, 'not_nullable_integer' => 1 })
        ).to be_valid
      end

      it 'accepts json as ruby hash' do
        expect(
          described_class.create(test: { nullable_string: nil, not_nullable_integer: 1 })
        ).to be_valid
      end

      it 'accepts json as string' do
        expect(
          described_class.create(test: '{ "nullable_string": null, "not_nullable_integer": 1 }')
        ).to be_valid
      end

      it 'does not accept invalid record' do
        expect(
          described_class.create(test: { 'nullable_string' => 'test' })
        ).to be_invalid
      end
    end
  end
end
