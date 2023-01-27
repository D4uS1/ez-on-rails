# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EzOnRails::Admin::BroomClosetService do
  # users
  let(:andrew) { create(:andrew) }
  let(:john) { create(:john) }

  # to test that nil owners are shown
  let(:anonymous_first_record) do
    create(:user_owned_record_without_validation,
           test: 'No ones first group',
           owner: nil)
  end
  let(:anonymous_second_record) do
    create(:user_owned_record_without_validation,
           test: 'No ones second group',
           owner: nil)
  end
  let(:anonymous_third_record) do
    create(:user_owned_record_without_validation,
           test: 'No ones third group',
           owner: nil)
  end

  # to test that valid owners are not shown
  let(:johns_first_record) do
    create(:user_owned_record_without_validation,
           test: 'Johns first resource',
           owner: john)
  end
  let(:johns_second_record) do
    create(:user_owned_record_without_validation,
           test: 'Johns second resource',
           owner: john)
  end
  let(:andrews_first_record) do
    create(:user_owned_record_without_validation,
           test: 'Andrews first resource',
           owner: andrew)
  end
  let(:andrews_second_record) do
    create(:user_owned_record_without_validation,
           test: 'Andrews second resource',
           owner: andrew)
  end

  # to test that valid attachments are not shown
  let(:attachment_valid_blob_one) { create(:eor_attachment_valid_blob_one) }
  let(:attachment_valid_blob_two) { create(:eor_attachment_valid_blob_two) }

  # to test that invalid attachments are shown
  let(:invalid_blob_one) do
    ActiveStorage::Blob.create_and_upload!(
      io: EzTestHelper.upload_file(EzOnRails::Engine.root.join('spec/active_storage_files/unattached_blob_1.png'),
                                   'image/png'),
      filename: 'unattached_blob_1.png',
      content_type: 'image/png'
    )
  end
  let(:invalid_blob_two) do
    ActiveStorage::Blob.create_and_upload!(
      io: EzTestHelper.upload_file(EzOnRails::Engine.root.join('spec/active_storage_files/unattached_blob_2.png'),
                                   'image/png'),
      filename: 'unattached_blob_2.png',
      content_type: 'image/png'
    )
  end
  let(:invalid_blob_three) do
    ActiveStorage::Blob.create_and_upload!(
      io: EzTestHelper.upload_file(EzOnRails::Engine.root.join('spec/active_storage_files/unattached_blob_3.png'),
                                   'image/png'),
      filename: 'unattached_blob_3.png',
      content_type: 'image/png'
    )
  end

  before do
    create(:eor_ownership_info,
           resource: 'UserOwnedRecord')

    anonymous_first_record
    anonymous_second_record
    anonymous_third_record
    johns_first_record
    johns_second_record
    andrews_first_record
    andrews_second_record

    stub_const('EzOnRails::Admin::BroomClosetService::UNATTACHED_FILES_MIN_AGE_MINUTES', 0)

    attachment_valid_blob_one
    attachment_valid_blob_two
    invalid_blob_one
    invalid_blob_two
    invalid_blob_three
  end

  after :all do
    clear_uploaded_test_files
  end

  context 'when calling nil_owners' do
    it 'returns owned resources without owner' do
      service = described_class.new

      result = service.nil_owners

      expect(result.length).to eq(3)
      expect(result).to include(anonymous_first_record)
      expect(result).to include(anonymous_second_record)
      expect(result).to include(anonymous_third_record)
    end

    it 'does not return owned resources with owner' do
      service = described_class.new

      result = service.nil_owners

      expect(result).not_to include(johns_first_record)
      expect(result).not_to include(johns_second_record)
      expect(result).not_to include(andrews_first_record)
      expect(result).not_to include(andrews_second_record)
    end
  end

  context 'when calling destroy_nil_owners' do
    it 'destroys passed resources without owner' do
      service = described_class.new

      service.destroy_nil_owners(
        [
          { id: anonymous_first_record.id, type: anonymous_first_record.class.to_s },
          { id: anonymous_third_record.id, type: anonymous_third_record.class.to_s }
        ]
      )

      nil_owners = service.nil_owners
      expect(nil_owners.length).to eq(1)
      expect(nil_owners).not_to include(anonymous_first_record)
      expect(nil_owners).to include(anonymous_second_record)
      expect(nil_owners).not_to include(anonymous_third_record)
    end

    it 'does not destroy selected resources with owner' do
      service = described_class.new

      service.destroy_nil_owners(
        [
          { id: andrews_first_record.id, type: andrews_first_record.class.to_s },
          { id: anonymous_third_record.id, type: anonymous_third_record.class.to_s }
        ]
      )

      expect(andrews_first_record.class.find(andrews_first_record.id)).not_to be_nil
    end
  end

  context 'when calling unattached files' do
    it 'returns unattached files' do
      service = described_class.new

      result = service.unattached_files

      expect(result.length).to eq(3)
      expect(result).to include(invalid_blob_one)
      expect(result).to include(invalid_blob_two)
      expect(result).to include(invalid_blob_three)
    end

    it 'does not return attached files' do
      service = described_class.new

      result = service.unattached_files

      expect(result).not_to include(attachment_valid_blob_one.blob)
      expect(result).not_to include(attachment_valid_blob_two.blob)
    end
  end

  context 'when calling destroy_unattached_files' do
    it 'destroys selected unattached files' do
      service = described_class.new

      service.destroy_unattached_files([invalid_blob_two.id, invalid_blob_three.id])

      unattached_files = service.unattached_files
      expect(unattached_files.length).to eq(1)
      expect(unattached_files).to include(invalid_blob_one)
    end

    it 'does not destroy selected attached files' do
      service = described_class.new

      service.destroy_unattached_files([attachment_valid_blob_one.blob.id, invalid_blob_three.id])

      attachment_valid_blob_one.reload
      expect(attachment_valid_blob_one.blob).not_to be_nil
    end
  end
end
