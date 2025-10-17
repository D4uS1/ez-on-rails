# frozen_string_literal: true

require 'rails_helper'

# Spec for testing the access for the actions in ApiKeyTests.
# Testing whether a non logged in user can not get any action, because the access should be denied.
# Testing whether some non super admin logged in user (called andrew here) can not get any action,
# because the access should be denied.
# Testing whether some super_admin can get the actions, because the access is granted.
RSpec.describe 'api_key_tests', type: :request do
  # users
  let(:andrew) { create(:andrew) } # non admin user
  let(:super_admin) { User.super_admin } # super administrator user

  # Test data
  let(:api_key_test) { create(:api_key_test) }
  let(:api_key_test_params) { attributes_for(:api_key_test) }

  # for test of update, destroy and show actions
  context 'when not logged in' do
    it 'can not get index' do
      get api_key_tests_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not get search' do
      get search_api_key_tests_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not search' do
      post search_api_key_tests_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not show api_key_test' do
      get api_key_test_url(id: api_key_test.id)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not get new' do
      get new_api_key_test_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not create' do
      post api_key_tests_url, params: { api_key_test: api_key_test_params }

      expect(ApiKeyTest.count).to eq(0)
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not get edit' do
      get edit_api_key_test_url(id: api_key_test.id)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not update api_key_test' do
      patch api_key_test_url(id: api_key_test.id), params: { api_key_test: api_key_test_params }

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not destroy api_key_test' do
      objects_count = api_key_test.class.count
      delete api_key_test_url(id: api_key_test.id)

      expect(ApiKeyTest.count).to eql(objects_count)
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not destroy selections' do
      create(:api_key_test, api_key_test_params)
      objects_count = api_key_test.class.count

      delete destroy_selections_api_key_tests_url, params: {
        selections: ActiveSupport::JSON.encode([{ data: { id: api_key_test.id }}])
      }

      expect(ApiKeyTest.count).to eq(objects_count)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'when logged in as andrew' do
    before do
      sign_in andrew
    end

    it 'can not get index' do
      get api_key_tests_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not get search' do
      get search_api_key_tests_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not search' do
      post search_api_key_tests_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not show api_key_test' do
      get api_key_test_url(id: api_key_test.id)

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not get new' do
      get new_api_key_test_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not create' do
      post api_key_tests_url, params: { api_key_test: api_key_test_params }

      expect(ApiKeyTest.count).to eq(0)
      expect(response).to have_http_status(:forbidden)
    end

    it 'can not get edit' do
      get edit_api_key_test_url(id: api_key_test.id)

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not update api_key_test' do
      patch api_key_test_url(id: api_key_test.id), params: { api_key_test: api_key_test_params }

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not destroy api_key_test' do
      objects_count = api_key_test.class.count
      delete api_key_test_url(id: api_key_test.id)

      expect(ApiKeyTest.count).to eql(objects_count)
      expect(response).to have_http_status(:forbidden)
    end

    it 'can not destroy selections' do
      create(:api_key_test, api_key_test_params)
      objects_count = api_key_test.class.count

      delete destroy_selections_api_key_tests_url, params: {
        selections: ActiveSupport::JSON.encode([{ data: { id: api_key_test.id }}])
      }

      expect(ApiKeyTest.count).to eq(objects_count)
      expect(response).to have_http_status(:forbidden)
    end
  end

  context 'when logged in as super admin' do
    before do
      sign_in super_admin
    end

    it 'can get index' do
      get api_key_tests_url

      expect(response).to have_http_status(:success)
    end

    it 'can get search' do
      get search_api_key_tests_url

      expect(response).to have_http_status(:success)
    end

    it 'can search' do
      post search_api_key_tests_url

      expect(response).to have_http_status(:success)
    end

    it 'can show api_key_test' do
      get api_key_test_url(id: api_key_test.id)

      expect(response).to have_http_status(:success)
    end

    it 'can get new' do
      get new_api_key_test_url

      expect(response).to have_http_status(:success)
    end

    it 'can create api_key_test' do
      post api_key_tests_url, params: { api_key_test: api_key_test_params }
      created_object = ApiKeyTest.last

      expect(ApiKeyTest.count).to eq(1)
      expect(response).to redirect_to(api_key_test_path(created_object))
    end

    it 'can get edit' do
      get edit_api_key_test_url(id: api_key_test.id)

      expect(response).to have_http_status(:success)
    end

    it 'can update api_key_test' do
      patch api_key_test_url(id: api_key_test.id), params: { api_key_test: api_key_test_params }

      expect(response).to redirect_to(api_key_test_path(api_key_test))
    end

    it 'can destroy api_key_test' do
      objects_count = api_key_test.class.count

      delete api_key_test_url(id: api_key_test.id)

      expect(ApiKeyTest.count).to eql(objects_count - 1)
      expect(response).to redirect_to(api_key_tests_url)
    end

    it 'can destroy selections' do
      create(:api_key_test, api_key_test_params)
      objects_count = api_key_test.class.count

      delete destroy_selections_api_key_tests_url, params: {
        selections: ActiveSupport::JSON.encode([{ data: { id: api_key_test.id }}])
      }

      expect(ApiKeyTest.count).to eq(objects_count - 1)
      expect(response).to have_http_status(:success)
    end
  end
end
