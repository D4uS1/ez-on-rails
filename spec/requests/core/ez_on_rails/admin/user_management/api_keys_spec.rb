# frozen_string_literal: true

require 'rails_helper'

# Spec for testing the access for the actions in Admin::UserManagement::ApiKeysController.
# Testing whether a non looged in user (called anonymus here) can not get any action, because the access
# should be denied.
# Testing whether some non admin logged in user (called andrew here) can not get any action, because the access should
# be denied.
# Testing whether admin can get the actions, because the access is granted.
# This spec also tests the basic CRUD functionality of the actions which should Create, Update or Destroy ActiveRecord
# instance.
RSpec.describe 'EzOnRails::Admin::UserManagement::ApiKeysController' do
  # users
  let(:andrew) { create(:andrew) }
  let(:john) { create(:john) }
  let(:admin) { User.super_admin }

  # for show, update and destroy actions
  let(:api_key) do
    create(:eor_api_key,
           api_key: 'ApiKey to update')
  end

  # for create actions
  let(:api_key_create) do
    build(:eor_api_key,
          api_key: 'ApiKey to create')
  end

  context 'when not logged in' do
    it 'can not get index' do
      get ez_on_rails_api_keys_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not get search' do
      get search_ez_on_rails_api_keys_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not search' do
      post search_ez_on_rails_api_keys_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not get new' do
      get new_ez_on_rails_api_key_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not create api_key' do
      post ez_on_rails_api_keys_url, params: {
        api_key: {
          api_key: api_key_create.api_key,
          expires_at: api_key_create.expires_at
        }
      }

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not show api_key' do
      get ez_on_rails_api_key_url(api_key)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not get edit' do
      get edit_ez_on_rails_api_key_url(api_key)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not update api_key' do
      patch ez_on_rails_api_key_url(api_key), params: {
        api_key: {
          api_key: api_key.api_key,
          owner_id: api_key.owner_id
        }
      }

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not destroy api_key' do
      delete ez_on_rails_api_key_url(api_key)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not destroy selections' do
      delete destroy_selections_ez_on_rails_api_keys_url

      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'when logged in as andrew' do
    before do
      sign_in andrew
    end

    it 'can not get index' do
      get ez_on_rails_api_keys_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not get search' do
      get search_ez_on_rails_api_keys_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not search' do
      post search_ez_on_rails_api_keys_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not get new' do
      get new_ez_on_rails_api_key_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not create api_key' do
      post ez_on_rails_api_keys_url, params: {
        api_key: {
          api_key: api_key_create.api_key,
          expires_at: api_key_create.expires_at
        }
      }

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not show api_key' do
      get ez_on_rails_api_key_url(api_key)

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not get edit' do
      get edit_ez_on_rails_api_key_url(api_key)

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not update api_key' do
      patch ez_on_rails_api_key_url(api_key), params: {
        api_key: {
          api_key: api_key.api_key,
          owner_id: api_key.owner_id
        }
      }

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not destroy api_key' do
      delete ez_on_rails_api_key_url(api_key)

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not destroy selections' do
      delete destroy_selections_ez_on_rails_api_keys_url

      expect(response).to have_http_status(:forbidden)
    end
  end

  context 'when logged in as admin' do
    before do
      sign_in admin
    end

    it 'can get index' do
      get ez_on_rails_api_keys_url

      expect(response).to have_http_status(:success)
    end

    it 'can get search' do
      get search_ez_on_rails_api_keys_url

      expect(response).to have_http_status(:success)
    end

    it 'can search' do
      post search_ez_on_rails_api_keys_url

      expect(response).to have_http_status(:success)
    end

    it 'can get new' do
      get new_ez_on_rails_api_key_url

      expect(response).to have_http_status(:success)
    end

    it 'can create api_key' do
      post ez_on_rails_api_keys_url, params: {
        api_key: {
          api_key: api_key_create.api_key,
          expires_at: api_key_create.expires_at
        }
      }

      created_object = EzOnRails::ApiKey.last
      expect(created_object.api_key).to eql(api_key_create.api_key)
      expect(response).to redirect_to(EzOnRails::ApiKey.last)
    end

    it 'can show api_key' do
      get ez_on_rails_api_key_url(api_key)

      expect(response).to have_http_status(:success)
    end

    it 'can get edit' do
      get edit_ez_on_rails_api_key_url(api_key)

      expect(response).to have_http_status(:success)
    end

    it 'can update api_key' do
      patch ez_on_rails_api_key_url(api_key), params: {
        api_key: {
          api_key: 'Updated ApiKey',
          owner_id: api_key.owner_id
        }
      }

      updated_object = EzOnRails::ApiKey.find api_key.id
      expect(updated_object.api_key).to eql('Updated ApiKey')
      expect(updated_object.owner_id).to eql(api_key.owner_id)

      expect(response).to redirect_to(api_key)
    end

    it 'can destroy api_key' do
      delete ez_on_rails_api_key_url(api_key)

      expect(EzOnRails::ApiKey.find_by(id: api_key.id)).to be_nil
      expect(response).to redirect_to(EzOnRails::ApiKey)
    end

    it 'can destroy selections' do
      delete destroy_selections_ez_on_rails_api_keys_url

      expect(response).to have_http_status(:success)
    end
  end
end
