# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EzOnRails::ResourceWriteAccess do
  let(:sharable_resource) do
    create(:sharable_resource)
  end
  let(:group) do
    create(:testgroup)
  end
  let(:resource_write_access_attributes) do
    {
      resource: sharable_resource,
      group:
    }
  end

  before do
    create(:eor_ownership_info, resource: 'SharableResource', sharable: true)
  end

  context 'when validating' do
    it 'creates valid record' do
      expect(described_class.create(resource_write_access_attributes)).to be_valid
    end

    it 'requires resource' do
      expect(described_class.create(resource_write_access_attributes.merge(
                                      resource: nil
                                    ))).not_to be_valid
    end

    it 'requires group' do
      expect(described_class.create(resource_write_access_attributes.merge(
                                      group: nil
                                    ))).not_to be_valid
    end

    it 'does not accept resourced that are not user owned' do
      EzOnRails::OwnershipInfo.find_by(resource: 'SharableResource').destroy!

      expect(described_class.create(resource_write_access_attributes)).not_to be_valid
    end

    it 'does not accept resources that are not sharable' do
      EzOnRails::OwnershipInfo.find_by(resource: 'SharableResource').update!(
        sharable: false
      )

      expect(described_class.create(resource_write_access_attributes)).not_to be_valid
    end
  end
end
