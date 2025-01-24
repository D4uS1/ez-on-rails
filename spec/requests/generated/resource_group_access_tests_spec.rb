# frozen_string_literal: true

require 'rails_helper'

# Spec for testing the access for the actions in ResourceGroupAccessTests.
# Testing whether a non looged in user can not get any action, because the access should be denied.
# Testing whether some non super admin logged in user (called andrew here) can not get any action,
# because the access should be denied.
# Testing whether some super_admin can get the actions, because the access is granted.
RSpec.describe 'resource_group_access_tests', type: :request do
  # users
  let(:andrew) { create(:andrew) } # non admin user
  let(:super_admin) { User.super_admin } # super administrator user

  # Test data
  let(:resource_group_access_test) { create(:resource_group_access_test) }
  let(:resource_group_access_test_params) { attributes_for(:resource_group_access_test) }

  # for test of update, destroy and show actions
  context 'when not logged in' do
    it 'can not get index' do
      get resource_group_access_tests_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not get search' do
      get search_resource_group_access_tests_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not search' do
      post search_resource_group_access_tests_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not show resource_group_access_test' do
      get resource_group_access_test_url(id: resource_group_access_test.id)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not get new' do
      get new_resource_group_access_test_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not create' do
      post resource_group_access_tests_url, params: { resource_group_access_test: resource_group_access_test_params }

      expect(ResourceGroupAccessTest.count).to eq(0)
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not get edit' do
      get edit_resource_group_access_test_url(id: resource_group_access_test.id)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not update resource_group_access_test' do
      patch resource_group_access_test_url(id: resource_group_access_test.id), params: { resource_group_access_test: resource_group_access_test_params }

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not destroy resource_group_access_test' do
      objects_count = resource_group_access_test.class.count
      delete resource_group_access_test_url(id: resource_group_access_test.id)

      expect(ResourceGroupAccessTest.count).to eql(objects_count)
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not destroy selections' do
      create(:resource_group_access_test, resource_group_access_test_params)
      objects_count = resource_group_access_test.class.count

      delete destroy_selections_resource_group_access_tests_url, params: {
        selections: ActiveSupport::JSON.encode([{ data: { id: resource_group_access_test.id }}])
      }

      expect(ResourceGroupAccessTest.count).to eq(objects_count)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'when logged in as andrew' do
    before do
      sign_in andrew
    end

    it 'can not get index' do
      get resource_group_access_tests_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not get search' do
      get search_resource_group_access_tests_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not search' do
      post search_resource_group_access_tests_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not show resource_group_access_test' do
      get resource_group_access_test_url(id: resource_group_access_test.id)

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not get new' do
      get new_resource_group_access_test_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not create' do
      post resource_group_access_tests_url, params: { resource_group_access_test: resource_group_access_test_params }

      expect(ResourceGroupAccessTest.count).to eq(0)
      expect(response).to have_http_status(:forbidden)
    end

    it 'can not get edit' do
      get edit_resource_group_access_test_url(id: resource_group_access_test.id)

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not update resource_group_access_test' do
      patch resource_group_access_test_url(id: resource_group_access_test.id), params: { resource_group_access_test: resource_group_access_test_params }

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not destroy resource_group_access_test' do
      objects_count = resource_group_access_test.class.count
      delete resource_group_access_test_url(id: resource_group_access_test.id)

      expect(ResourceGroupAccessTest.count).to eql(objects_count)
      expect(response).to have_http_status(:forbidden)
    end

    it 'can not destroy selections' do
      create(:resource_group_access_test, resource_group_access_test_params)
      objects_count = resource_group_access_test.class.count

      delete destroy_selections_resource_group_access_tests_url, params: {
        selections: ActiveSupport::JSON.encode([{ data: { id: resource_group_access_test.id }}])
      }

      expect(ResourceGroupAccessTest.count).to eq(objects_count)
      expect(response).to have_http_status(:forbidden)
    end
  end

  context 'when logged in as super admin' do
    before do
      sign_in super_admin
    end

    it 'can get index' do
      get resource_group_access_tests_url

      expect(response).to have_http_status(:success)
    end

    it 'can get search' do
      get search_resource_group_access_tests_url

      expect(response).to have_http_status(:success)
    end

    it 'can search' do
      post search_resource_group_access_tests_url

      expect(response).to have_http_status(:success)
    end

    it 'can show resource_group_access_test' do
      get resource_group_access_test_url(id: resource_group_access_test.id)

      expect(response).to have_http_status(:success)
    end

    it 'can get new' do
      get new_resource_group_access_test_url

      expect(response).to have_http_status(:success)
    end

    it 'can create resource_group_access_test' do
      post resource_group_access_tests_url, params: { resource_group_access_test: resource_group_access_test_params }
      created_object = ResourceGroupAccessTest.last

      expect(ResourceGroupAccessTest.count).to eq(1)
      expect(response).to redirect_to(resource_group_access_test_path(created_object))
    end

    it 'can get edit' do
      get edit_resource_group_access_test_url(id: resource_group_access_test.id)

      expect(response).to have_http_status(:success)
    end

    it 'can update resource_group_access_test' do
      patch resource_group_access_test_url(id: resource_group_access_test.id), params: { resource_group_access_test: resource_group_access_test_params }

      expect(response).to redirect_to(resource_group_access_test_path(resource_group_access_test))
    end

    it 'can destroy resource_group_access_test' do
      objects_count = resource_group_access_test.class.count

      delete resource_group_access_test_url(id: resource_group_access_test.id)

      expect(ResourceGroupAccessTest.count).to eql(objects_count - 1)
      expect(response).to redirect_to(resource_group_access_tests_url)
    end

    it 'can destroy selections' do
      create(:resource_group_access_test, resource_group_access_test_params)
      objects_count = resource_group_access_test.class.count

      delete destroy_selections_resource_group_access_tests_url, params: {
        selections: ActiveSupport::JSON.encode([{ data: { id: resource_group_access_test.id }}])
      }

      expect(ResourceGroupAccessTest.count).to eq(objects_count - 1)
      expect(response).to have_http_status(:success)
    end
  end
end
