# frozen_string_literal: true

require 'rails_helper'

# Spec for testing the access for the actions in Api::UsersController.
RSpec.describe 'Api::UsersController' do
  # users
  let(:andrew) { create(:andrew) }
  let(:default_headers) { { ACCEPT: 'application/json', 'api-version': API_VERSION } }
  let(:avatar_blob) { create(:eor_attachment_valid_blob_one) }
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

  context 'when not logged in' do
    it 'can not get me' do
      get api_users_me_url, headers: default_headers

      expect(response).to have_http_status(:unauthorized)
    end

    it 'can not update me' do
      patch api_users_me_url, headers: default_headers, params: {
        user: {
          username: 'NewUsername'
        }
      }

      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'when logged in as andrew' do
    it 'can get me' do
      get api_users_me_url, headers: auth_headers_andrew

      expect(response).to have_http_status(:success)
    end

    it 'can update me' do
      get api_users_me_url, headers: auth_headers_andrew, params: {
        user: {
          username: 'NewUsername'
        }
      }

      expect(response).to have_http_status(:success)
    end
  end

  context 'when requesting me' do
    it 'returns username and email and no avatar if no avatar is given' do
      get api_users_me_url, headers: auth_headers_andrew

      response_body = JSON.parse(response.body)

      expect(response_body['email']).to eq(andrew.email)
      expect(response_body['username']).to eq(andrew.username)
      expect(response_body['avatar']).to be_nil
    end

    it 'returns username and email and avatar if avatar is given' do
      andrew.update(avatar: avatar_blob.signed_id)

      get api_users_me_url, headers: auth_headers_andrew

      response_body = JSON.parse(response.body)
      expect(response_body['email']).to eq(andrew.email)
      expect(response_body['username']).to eq(andrew.username)
      expect(response_body['avatar']['path']).not_to be_nil
      expect(response_body['avatar']['filename']).not_to be_nil
      expect(response_body['avatar']['signed_id']).not_to be_nil
    end

    it 'does not return password information' do
      get api_users_me_url, headers: auth_headers_andrew

      response_body = JSON.parse(response.body)
      expect(response_body['password']).to be_nil
      expect(response_body['password_confirmation']).to be_nil
      expect(response_body['encrypted_password']).to be_nil
    end

    it 'returns unconfirmed_email if exists' do
      andrew.update(email: 'new_email@address.de')

      get api_users_me_url, headers: auth_headers_andrew

      response_body = JSON.parse(response.body)
      expect(response_body['unconfirmed_email']).to eq('new_email@address.de')
    end
  end

  context 'when requesting update me' do
    it 'updates username and avatar and states email as unconfirmed' do
      old_email = andrew.email

      patch api_users_me_url, headers: auth_headers_andrew, params: {
        user: {
          username: 'NewUsername',
          email: 'new_email@whatever.com',
          avatar: avatar_blob.signed_id
        }
      }

      andrew.reload

      expect(andrew.email).to eq(old_email)
      expect(andrew.unconfirmed_email).to eq('new_email@whatever.com')
      expect(andrew.username).to eq('NewUsername')
      expect(andrew.avatar.attached?).to be(true)
    end

    it 'returns new user info after update' do
      old_email = andrew.email

      patch api_users_me_url, headers: auth_headers_andrew, params: {
        user: {
          username: 'NewUsername',
          email: 'new_email@whatever.com',
          avatar: avatar_blob.signed_id
        }
      }

      andrew.reload

      response_body = JSON.parse(response.body)
      expect(response_body['email']).to eq(old_email)
      expect(response_body['unconfirmed_email']).to eq('new_email@whatever.com')
      expect(response_body['username']).to eq('NewUsername')
      expect(response_body['avatar']['path']).not_to be_nil
      expect(response_body['avatar']['filename']).not_to be_nil
      expect(response_body['avatar']['signed_id']).not_to be_nil
    end

    it 'updates password if password_confirmation is set correctly' do
      old_password = andrew.encrypted_password

      patch api_users_me_url, headers: auth_headers_andrew, params: {
        user: {
          password: 'newPassword',
          password_confirmation: 'newPassword'
        }
      }

      andrew.reload
      expect(andrew.encrypted_password).not_to eq(old_password)
      expect(andrew.encrypted_password).not_to eq('newPassword')
    end

    it 'does not update password if password_confirmation is given but does not match' do
      old_password = andrew.encrypted_password

      patch api_users_me_url, headers: auth_headers_andrew, params: {
        user: {
          password: 'newPassword',
          password_confirmation: 'newPasswordWrong'
        }
      }

      andrew.reload
      expect(response).to have_http_status(:unprocessable_entity)
      expect(andrew.encrypted_password).to eq(old_password)
    end

    it 'updates password if no password_confirmation is given' do
      old_password = andrew.encrypted_password

      patch api_users_me_url, headers: auth_headers_andrew, params: {
        user: {
          password: 'newPassword'
        }
      }

      andrew.reload
      expect(response).to have_http_status(:success)
      expect(andrew.encrypted_password).not_to eq(old_password)
      expect(andrew.encrypted_password).not_to eq('newPassword')
    end

    it 'does not return password information' do
      patch api_users_me_url, headers: auth_headers_andrew, params: {
        user: {
          password: 'newPassword',
          password_confirmation: 'newPassword'
        }
      }

      response_body = JSON.parse(response.body)
      expect(response_body['password']).to be_nil
      expect(response_body['password_confirmation']).to be_nil
      expect(response_body['encrypted_password']).to be_nil
    end

    it 'returns unconfirmed_email after updating email' do
      patch api_users_me_url, headers: auth_headers_andrew, params: {
        user: {
          email: 'new_email@address.de'
        }
      }

      response_body = JSON.parse(response.body)
      expect(response_body['unconfirmed_email']).to eq('new_email@address.de')
    end
  end
end
