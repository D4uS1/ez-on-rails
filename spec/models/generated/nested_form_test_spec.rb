# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NestedFormTest, type: :model do
  let(:parent_form_test) { create(:parent_form_test) }
  let(:valid_attributes) { attributes_for(:nested_form_test, parent_form_test_id: parent_form_test.id) }

  context 'when validating' do
    it 'creates a valid record' do
      expect(described_class.create(valid_attributes)).to be_valid
    end
  end
end
