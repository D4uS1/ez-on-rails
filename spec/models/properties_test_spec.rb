# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PropertiesTest, type: :model do
  let(:valid_attributes) do
    attributes_for(
      :properties_test,
      assoc_test_id: create(:assoc_test).id
    )
  end

  context 'when validating' do
    it 'creates a valid record' do
      expect(described_class.create(valid_attributes)).to be_valid
    end
  end
end
