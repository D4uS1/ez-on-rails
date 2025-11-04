# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EzOnRails::ApplicationRecord do
  let(:valid_attributes) { attributes_for(:andrew).merge({ password: 'testpassword' }) }

  context 'when using other methods' do
    context 'when using search_keys' do
      it 'returns all attributes' do
        expect(BearerTokenAccessTest.search_keys).to eq(%i[id test owner_id created_at updated_at])
      end
    end

    context 'when using wrapped_parameter_names' do
      it 'returns all attributes and active storage relation names' do
        expect(BearerTokenAccessTest.wrapped_parameter_names).to eq(
          %i[id test owner_id created_at updated_at file images]
        )
      end
    end

    context 'when using active_storage_relation_names' do
      it 'returns has_many_attached relation names' do
        expect(BearerTokenAccessTest.active_storage_relation_names).to include(:images)
      end

      it 'returns has_one_attached relation names' do
        expect(BearerTokenAccessTest.active_storage_relation_names).to include(:file)
      end
    end
  end
end
