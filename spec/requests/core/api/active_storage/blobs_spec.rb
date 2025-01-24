# frozen_string_literal: true

require 'rails_helper'

# Spec for testing the access for the actions in Admin::BroomCloset::NilOwnersController.
# Testing whether a non looged in user (called anonymus here) can not get any action, because the access can be denied.
# Testing whether some non admin logged in user (called andrew here) can not get any action,
# because the access can be denied.
# Testing whether admin can get the actions, because the access is granted.
RSpec.describe 'Api::ActiveStorage::BlobsController' do
  # users
  let(:andrew) { create(:andrew) }
  let(:admin) { User.super_admin }
  let(:blob) { create(:eor_attachment_valid_blob_one) }
  let(:default_headers) { { ACCEPT: 'application/json', 'api-version': API_VERSION } }
  let(:auth_headers_andrew) do
    auth_headers = authorization_header_info(andrew)
    default_headers.merge(
      {
        uid: auth_headers[:uid],
        'access-token': auth_headers[:token],
        client: auth_headers[:client]
      }
    )
  end
  let(:auth_headers_admin) do
    auth_headers = authorization_header_info(admin)
    default_headers.merge(
      {
        uid: auth_headers[:uid],
        'access-token': auth_headers[:token],
        client: auth_headers[:client]
      }
    )
  end
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
      post create_direct_upload_api_active_storage_blobs_path,
           params: direct_upload_create_params,
           headers: default_headers

      expect(response).to have_http_status(:unauthorized)
    end

    it 'can not get destroy' do
      delete api_active_storage_blob_path(signed_id: blob.signed_id), headers: default_headers

      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'when logged in as andrew' do
    before do
      sign_in andrew
    end

    it 'can get create_direct_upload' do
      post create_direct_upload_api_active_storage_blobs_path,
           params: direct_upload_create_params,
           headers: auth_headers_andrew

      expect(response).to have_http_status(:success)
    end

    it 'can get destroy' do
      delete api_active_storage_blob_path(signed_id: blob.signed_id), headers: auth_headers_andrew

      expect(response).to have_http_status(:success)
    end
  end

  context 'when logged in as admin' do
    before do
      sign_in admin
    end

    it 'can get create_direct_upload' do
      post create_direct_upload_api_active_storage_blobs_path,
           params: direct_upload_create_params,
           headers: auth_headers_admin

      expect(response).to have_http_status(:success)
    end

    it 'can get destroy' do
      delete api_active_storage_blob_path(signed_id: blob.signed_id), headers: auth_headers_admin

      expect(response).to have_http_status(:success)
    end
  end
end
