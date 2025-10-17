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

    it 'requires api_key' do
      expect(described_class.create(api_key_attributes.merge(api_key: nil))).not_to be_valid
    end

    it 'has unique api_key' do
      described_class.create(api_key_attributes)

      expect(described_class.create(api_key_attributes)).not_to be_valid
    end
  end
end
