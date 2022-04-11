# frozen_string_literal: true

require 'rails_helper'

# Spec for testing the behavior of the broom closets unattached files capabilities.
# Testing if the admin is able to see and delete file blobs, which are not attached to any record.
RSpec.describe 'Unattached files user view', type: :system do
  before do
    stub_const('EzOnRails::Admin::BroomClosetService::UNATTACHED_FILES_MIN_AGE_MINUTES', 0)
  end

  let!(:attachment_valid_blob_one) { create(:eor_attachment_valid_blob_one) }
  let!(:attachment_valid_blob_two) { create(:eor_attachment_valid_blob_two) }
  let!(:invalid_blob_one) do
    ActiveStorage::Blob.create_and_upload!(
      io: EzTestHelper.upload_file(EzOnRails::Engine.root.join('spec/active_storage_files/unattached_blob_1.png'),
                                   'image/png'),
      filename: 'unattached_blob_1.png',
      content_type: 'image/png'
    )
  end
  let!(:invalid_blob_two) do
    ActiveStorage::Blob.create_and_upload!(
      io: EzTestHelper.upload_file(EzOnRails::Engine.root.join('spec/active_storage_files/unattached_blob_2.png'),
                                   'image/png'),
      filename: 'unattached_blob_2.png',
      content_type: 'image/png'
    )
  end
  let!(:invalid_blob_three) do
    ActiveStorage::Blob.create_and_upload!(
      io: EzTestHelper.upload_file(EzOnRails::Engine.root.join('spec/active_storage_files/unattached_blob_3.png'),
                                   'image/png'),
      filename: 'unattached_blob_3.png',
      content_type: 'image/png'
    )
  end

  after :all do
    FileUtils.rm_rf Rails.root.join('tmp/storage')
    FileUtils.mkdir Rails.root.join('tmp/storage')
  end

  context 'when logged in as admin' do
    before do
      system_log_in User.super_admin.email, '1replace_me3_after3_install7'
    end

    it 'can not see attached files' do
      visit 'ez_on_rails/admin/broom_closet/unattached_files/'

      expect(page).not_to have_text attachment_valid_blob_one.filename
      expect(page).not_to have_text attachment_valid_blob_two.filename
    end

    it 'can see unattached files' do
      visit 'ez_on_rails/admin/broom_closet/unattached_files/'

      expect(page).to have_text invalid_blob_one.filename
      expect(page).to have_text invalid_blob_two.filename
      expect(page).to have_text invalid_blob_three.filename
    end

    it 'deletes one unattached file' do
      visit 'ez_on_rails/admin/broom_closet/unattached_files/'

      first('#enhanced_table_select_row_enhanced_table').check
      click_on t(:'ez_on_rails.destroy_selection')
      system_confirm_modal

      expect(page).to have_text t(:'ez_on_rails.unattached_files_success')
      expect(page).not_to have_text invalid_blob_one.filename
      expect(page).to have_text invalid_blob_two.filename
      expect(page).to have_text invalid_blob_three.filename
    end

    it 'deletes all unattached files' do
      visit 'ez_on_rails/admin/broom_closet/unattached_files/'

      click_on t(:'ez_on_rails.destroy_all')
      system_confirm_modal

      expect(page).to have_text t(:'ez_on_rails.unattached_files_success')
      expect(page).not_to have_text invalid_blob_one.filename
      expect(page).not_to have_text invalid_blob_two.filename
      expect(page).not_to have_text invalid_blob_three.filename
    end
  end
end
