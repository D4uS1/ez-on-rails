# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EzOnRails::ApiKey do
  let(:api_key_attributes) do
    {
      api_key: 'Testgroup',
      expires_at: 2.days.since
    }
  end

  context 'when validating' do
    it 'creates valid record' do
      expect(described_class.create(api_key_attributes)).to be_valid
    end

    it 'has unique api_key' do
      described_class.create(api_key_attributes)

      expect(described_class.create(api_key_attributes)).not_to be_valid
    end
  end

  context 'when using hooks' do
    context 'when using generate_api_key' do
      it 'generates api_key if it was blank' do
        record = described_class.create(api_key_attributes.merge({ api_key: nil }))

        expect(record.api_key).not_to be_nil
        expect(record.api_key.length).to eq(64)
      end

      it 'does not overwrite api_key if it was not blank' do
        record = described_class.create(api_key_attributes.merge({ api_key: 'given_api_key' }))

        expect(record.api_key).to eq('given_api_key')
      end
    end
  end
end
