# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AssocTest do
  let(:valid_attributes) do
    attributes_for(
      :assoc_test,
      bearer_token_access_test_id: create(:bearer_token_access_test).id,
      parent_form_test_id: create(:parent_form_test).id
    )
  end

  context 'when validating' do
    it 'creates a valid record' do
      expect(described_class.create(valid_attributes)).to be_valid
    end
  end
end
