# frozen_string_literal: true

require 'rails_helper'

# Spec for testing the access for the actions in Admin::BroomCloset::UnattachedFilesController.
# Testing whether a non looged in user (called anonymus here) can not get any action, because the access can be denied.
# Testing whether some non admin logged in user (called andrew here) can not get any action, because the
# access can be denied.
# Testing whether admin can get the actions, because the access is granted.
RSpec.describe 'EzOnRails::Admin::BroomCloset::UnattachedFilesController' do
  # users
  let(:andrew) { create(:andrew) }
  let(:admin) { User.super_admin }

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
    attachment_valid_blob_one
    attachment_valid_blob_two
    invalid_blob_one
    invalid_blob_two
    invalid_blob_three
  end

  after :all do
    clear_uploaded_test_files
  end

  context 'when not logged in' do
    it 'can not get index' do
      get ez_on_rails_unattached_files_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not get search' do
      get ez_on_rails_unattached_files_search_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not search' do
      post ez_on_rails_unattached_files_search_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not destroy selections' do
      delete ez_on_rails_unattached_files_destroy_selections_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not destroy all' do
      delete ez_on_rails_unattached_files_destroy_all_url

      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'when logged in as andrew' do
    before do
      sign_in andrew
    end

    it 'can not get index' do
      get ez_on_rails_unattached_files_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not get search' do
      get ez_on_rails_unattached_files_search_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not search' do
      post ez_on_rails_unattached_files_search_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not destroy selections' do
      delete ez_on_rails_unattached_files_destroy_selections_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not destroy all' do
      delete ez_on_rails_unattached_files_destroy_all_url

      expect(response).to have_http_status(:forbidden)
    end
  end

  context 'when logged in as admin' do
    before do
      sign_in admin
    end

    it 'can get index' do
      get ez_on_rails_unattached_files_url

      expect(response).to have_http_status(:success)
    end

    it 'can get search' do
      get ez_on_rails_unattached_files_search_url

      expect(response).to have_http_status(:success)
    end

    it 'can search' do
      post ez_on_rails_unattached_files_search_url

      expect(response).to have_http_status(:success)
    end

    it 'can destroy selections' do
      delete ez_on_rails_unattached_files_destroy_selections_url

      expect(response).to have_http_status(:success)
    end

    it 'can destroy all' do
      delete ez_on_rails_unattached_files_destroy_all_url

      expect(response).to redirect_to(ez_on_rails_unattached_files_url)
    end
  end

  context 'when requesting destroy_selections' do
    before do
      sign_in admin
    end

    it 'destroys selected unattached files' do
      delete ez_on_rails_unattached_files_destroy_selections_url, params: {
        selections: ActiveSupport::JSON.encode([{ data: {
                                                 id: invalid_blob_one.id
                                               } }])
      }

      unattached_files = EzOnRails::Admin::BroomClosetService.new.unattached_files
      expect(response).to have_http_status(:success)
      expect(unattached_files).not_to include(invalid_blob_one)
    end

    it 'does not destroy selected attached files' do
      delete ez_on_rails_unattached_files_destroy_selections_url, params: {
        selections: ActiveSupport::JSON.encode([{ data: {
                                                 id: attachment_valid_blob_one.blob.id
                                               } }])
      }

      attachment_valid_blob_one.reload
      expect(response).to have_http_status(:success)
      expect(attachment_valid_blob_one.blob).not_to be_nil
    end
  end

  context 'when requesting destroy_all' do
    before do
      sign_in admin
    end

    it 'destroys all unattached files' do
      delete ez_on_rails_unattached_files_destroy_all_url

      unattached_files = EzOnRails::Admin::BroomClosetService.new.unattached_files
      expect(response).to redirect_to(ez_on_rails_unattached_files_url)
      expect(unattached_files.length).to eq(0)
    end

    it 'does not destroy attached files' do
      delete ez_on_rails_unattached_files_destroy_all_url

      attachment_valid_blob_one.reload
      attachment_valid_blob_two.reload
      expect(attachment_valid_blob_one.blob).not_to be_nil
      expect(attachment_valid_blob_two.blob).not_to be_nil
    end
  end
end
