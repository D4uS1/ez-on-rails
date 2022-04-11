# frozen_string_literal: true

require 'rails_helper'

# Spec for testing the access for the actions in Admin::BroomCloset::NilOwnersController.
# Testing whether a non looged in user (called anonymus here) can not get any action, because the access can be denied.
# Testing whether some non admin logged in user (called andrew here) can not get any action,
# because the access can be denied.
# Testing whether admin can get the actions, because the access is granted.
RSpec.describe 'ez_on_rails/active_storage/blobs', type: :request do
  # users
  let(:andrew) { create(:andrew) }
  let(:admin) { User.super_admin }
  let(:blob) { create(:eor_attachment_valid_blob_one) }
  let(:direct_upload_create_params) do
    {
      blob: attributes_for(:eor_attachment_valid_blob_one).merge(
        {
          filename: 'valid_blob_1.png',
          byte_size: 100,
          checksum: 100
        }
      )
    }
  end

  context 'when not logged in' do
    it 'can not get create_direct_upload' do
      post create_direct_upload_ez_on_rails_active_storage_blobs_path,
           params: direct_upload_create_params

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not get destroy' do
      delete ez_on_rails_active_storage_blob_path(signed_id: blob.signed_id)

      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'when logged in as andrew' do
    before do
      sign_in andrew
    end

    it 'can get create_direct_upload' do
      post create_direct_upload_ez_on_rails_active_storage_blobs_path,
           params: direct_upload_create_params

      expect(response).to have_http_status(:success)
    end

    it 'can get destroy' do
      delete ez_on_rails_active_storage_blob_path(signed_id: blob.signed_id)

      expect(response).to have_http_status(:success)
    end
  end

  context 'when logged in as admin' do
    before do
      sign_in admin
    end

    it 'can create direct upload' do
      post create_direct_upload_ez_on_rails_active_storage_blobs_path,
           params: direct_upload_create_params

      expect(response).to have_http_status(:success)
    end

    it 'can get destroy' do
      delete ez_on_rails_active_storage_blob_path(signed_id: blob.signed_id)

      expect(response).to have_http_status(:success)
    end
  end
end
