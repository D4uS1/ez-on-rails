# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApiKeyTest, type: :model do
  let(:valid_attributes) { attributes_for(:api_key_test) }

  context 'when validating' do
    it 'creates a valid record' do
      expect(described_class.create(valid_attributes)).to be_valid
    end
  end
end
