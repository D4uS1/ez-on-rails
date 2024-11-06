# frozen_string_literal: true

require 'rails_helper'

# Spec for testing the access for the actions in ParentFormTests.
# Testing whether a non looged in user can not get any action, because the access should be denied.
# Testing whether some non super admin logged in user (called andrew here) can not get any action,
# because the access should be denied.
# Testing whether some super_admin can get the actions, because the access is granted.
RSpec.describe 'parent_form_tests', type: :request do
  # users
  let(:andrew) { create(:andrew) } # non admin user
  let(:super_admin) { User.super_admin } # super administrator user

  # Test data
  let(:parent_form_test) { create(:parent_form_test) }
  let(:parent_form_test_params) { attributes_for(:parent_form_test) }

  # for test of update, destroy and show actions
  context 'when not logged in' do
    it 'can not get index' do
      get parent_form_tests_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not get search' do
      get search_parent_form_tests_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not search' do
      post search_parent_form_tests_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not show parent_form_test' do
      get parent_form_test_url(id: parent_form_test.id)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not get new' do
      get new_parent_form_test_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not create' do
      post parent_form_tests_url, params: { parent_form_test: parent_form_test_params }

      expect(ParentFormTest.count).to eq(0)
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not get edit' do
      get edit_parent_form_test_url(id: parent_form_test.id)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not update parent_form_test' do
      patch parent_form_test_url(id: parent_form_test.id), params: { parent_form_test: parent_form_test_params }

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not destroy parent_form_test' do
      objects_count = parent_form_test.class.count
      delete parent_form_test_url(id: parent_form_test.id)

      expect(ParentFormTest.count).to eql(objects_count)
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not destroy selections' do
      create(:parent_form_test, parent_form_test_params)
      objects_count = parent_form_test.class.count

      delete destroy_selections_parent_form_tests_url, params: {
          selections: ActiveSupport::JSON.encode([{ data: { id: parent_form_test.id }}])
      }

      expect(ParentFormTest.count).to eq(objects_count)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'when logged in as andrew' do
    before do
      sign_in andrew
    end

    it 'can not get index' do
      get parent_form_tests_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not get search' do
      get search_parent_form_tests_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not search' do
      post search_parent_form_tests_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not show parent_form_test' do
      get parent_form_test_url(id: parent_form_test.id)

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not get new' do
      get new_parent_form_test_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not create' do
      post parent_form_tests_url, params: { parent_form_test: parent_form_test_params }

      expect(ParentFormTest.count).to eq(0)
      expect(response).to have_http_status(:forbidden)
    end

    it 'can not get edit' do
      get edit_parent_form_test_url(id: parent_form_test.id)

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not update parent_form_test' do
      patch parent_form_test_url(id: parent_form_test.id), params: { parent_form_test: parent_form_test_params }

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not destroy parent_form_test' do
      objects_count = parent_form_test.class.count
      delete parent_form_test_url(id: parent_form_test.id)

      expect(ParentFormTest.count).to eql(objects_count)
      expect(response).to have_http_status(:forbidden)
    end

    it 'can not destroy selections' do
      create(:parent_form_test, parent_form_test_params)
      objects_count = parent_form_test.class.count

      delete destroy_selections_parent_form_tests_url, params: {
          selections: ActiveSupport::JSON.encode([{ data: { id: parent_form_test.id }}])
      }

      expect(ParentFormTest.count).to eq(objects_count)
      expect(response).to have_http_status(:forbidden)
    end
  end

  context 'when logged in as super admin' do
    before do
      sign_in super_admin
    end

    it 'can get index' do
      get parent_form_tests_url

      expect(response).to have_http_status(:success)
    end

    it 'can get search' do
      get search_parent_form_tests_url

      expect(response).to have_http_status(:success)
    end

    it 'can search' do
      post search_parent_form_tests_url

      expect(response).to have_http_status(:success)
    end

    it 'can show parent_form_test' do
      get parent_form_test_url(id: parent_form_test.id)

      expect(response).to have_http_status(:success)
    end

    it 'can get new' do
      get new_parent_form_test_url

      expect(response).to have_http_status(:success)
    end

    it 'can create parent_form_test' do
      post parent_form_tests_url, params: { parent_form_test: parent_form_test_params }
      created_object = ParentFormTest.last

      expect(ParentFormTest.count).to eq(1)
      expect(response).to redirect_to(parent_form_test_path(created_object))
    end

    it 'can get edit' do
      get edit_parent_form_test_url(id: parent_form_test.id)

      expect(response).to have_http_status(:success)
    end

    it 'can update parent_form_test' do
      patch parent_form_test_url(id: parent_form_test.id), params: { parent_form_test: parent_form_test_params }

      expect(response).to redirect_to(parent_form_test_path(parent_form_test))
    end

    it 'can destroy parent_form_test' do
      objects_count = parent_form_test.class.count

      delete parent_form_test_url(id: parent_form_test.id)

      expect(ParentFormTest.count).to eql(objects_count - 1)
      expect(response).to redirect_to(parent_form_tests_url)
    end

    it 'can destroy selections' do
      create(:parent_form_test, parent_form_test_params)
      objects_count = parent_form_test.class.count

      delete destroy_selections_parent_form_tests_url, params: {
          selections: ActiveSupport::JSON.encode([{ data: { id: parent_form_test.id }}])
      }

      expect(ParentFormTest.count).to eq(objects_count - 1)
      expect(response).to redirect_to(parent_form_tests_url)
    end
  end
end
