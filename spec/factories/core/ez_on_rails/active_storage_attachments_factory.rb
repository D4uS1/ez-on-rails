# frozen_string_literal: true

FactoryBot.define do
  factory :eor_active_storage_attachment, class: 'ActiveStorage::Attachment' do
    to_create { |instance| instance.save(validate: false) }

    record_type { 'User' }
    record_id { User.super_admin.id }
    created_at { '2019-01-01' }

    # Attachments to define some valid blobs who are assigned to this attachments, hence the blobs
    # should not appear in broom closet area
    factory :eor_attachment_valid_blob_one do
      name { 'valid blob one' }
      blob do
        ActiveStorage::Blob.create_and_upload!(
          io: EzTestHelper.upload_file(EzOnRails::Engine.root.join('spec', 'active_storage_files', 'valid_blob_1.png'),
                                       'image/png'),
          filename: 'valid_blob_1.png',
          content_type: 'image/png'
        )
      end
    end

    factory :eor_attachment_valid_blob_two do
      name { 'valid blob two' }
      blob do
        ActiveStorage::Blob.create_and_upload!(
          io: EzTestHelper.upload_file(EzOnRails::Engine.root.join('spec', 'active_storage_files', 'valid_blob_2.png'),
                                       'image/png'),
          filename: 'valid_blob_2.png',
          content_type: 'image/png'
        )
      end
    end
  end
end
