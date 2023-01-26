# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EzOnRails::OwnershipInfo do
  let(:ownership_info_attributes) do
    {
      resource: 'EzOnRails::Group',
      sharable: false
    }
  end

  context 'when validating' do
    it 'creates valid record' do
      expect(described_class.create(ownership_info_attributes)).to be_valid
    end

    it 'requires resource' do
      expect(described_class.create(ownership_info_attributes.merge(resource: nil))).to be_invalid
    end

    it 'has unique resource' do
      described_class.create(ownership_info_attributes)

      expect(described_class.create(ownership_info_attributes)).to be_invalid
    end

    it 'rejects not existing resource' do
      expect(described_class.create(resource: 'NonExisting')).to be_invalid
    end
  end

  context 'when using hooks' do
    it 'revises name of resource' do
      resource = described_class.create!(resource: 'ez_on_rails/group')

      expect(resource).to be_valid
      expect(resource.resource).to eq('EzOnRails::Group')
    end
  end
end
