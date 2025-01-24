# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ResourceGroupAccessTest do
  let(:valid_attributes) { attributes_for(:resource_group_access_test) }

  context 'when validating' do
    it 'creates a valid record' do
      expect(described_class.create(valid_attributes)).to be_valid
    end
  end
end
