# frozen_string_literal: true

require 'rails_helper'

# Spec for testing the access for the actions in AssocTests.
# Testing whether a non looged in user can not get any action, because the access should be denied.
# Testing whether some non super admin logged in user (called andrew here) can not get any action,
# because the access should be denied.
# Testing whether some super_admin can get the actions, because the access is granted.
RSpec.describe 'assoc_tests', type: :request do
  # users
  let(:andrew) { create(:andrew) } # non admin user
  let(:super_admin) { User.super_admin } # super administrator user

  # Test data
  let(:assoc_test) { create(:assoc_test) }
  let(:assoc_test_params) do
    attributes_for(
      :assoc_test,
      bearer_token_access_test_id: create(:bearer_token_access_test).id,
      parent_form_test_id: create(:parent_form_test).id
    )
  end

  # for test of update, destroy and show actions
  context 'when not logged in' do
    it 'can not get index' do
      get assoc_tests_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not get search' do
      get search_assoc_tests_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not search' do
      post search_assoc_tests_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not show assoc_test' do
      get assoc_test_url(id: assoc_test.id)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not get new' do
      get new_assoc_test_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not create' do
      post assoc_tests_url, params: { assoc_test: assoc_test_params }

      expect(AssocTest.count).to eq(0)
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not get edit' do
      get edit_assoc_test_url(id: assoc_test.id)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not update assoc_test' do
      patch assoc_test_url(id: assoc_test.id), params: { assoc_test: assoc_test_params }

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not destroy assoc_test' do
      objects_count = assoc_test.class.count
      delete assoc_test_url(id: assoc_test.id)

      expect(AssocTest.count).to eql(objects_count)
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not destroy selections' do
      create(:assoc_test, assoc_test_params)
      objects_count = assoc_test.class.count

      delete destroy_selections_assoc_tests_url, params: {
        selections: ActiveSupport::JSON.encode([{ data: { id: assoc_test.id }}])
      }

      expect(AssocTest.count).to eq(objects_count)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'when logged in as andrew' do
    before do
      sign_in andrew
    end

    it 'can not get index' do
      get assoc_tests_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not get search' do
      get search_assoc_tests_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not search' do
      post search_assoc_tests_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not show assoc_test' do
      get assoc_test_url(id: assoc_test.id)

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not get new' do
      get new_assoc_test_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not create' do
      post assoc_tests_url, params: { assoc_test: assoc_test_params }

      expect(AssocTest.count).to eq(0)
      expect(response).to have_http_status(:forbidden)
    end

    it 'can not get edit' do
      get edit_assoc_test_url(id: assoc_test.id)

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not update assoc_test' do
      patch assoc_test_url(id: assoc_test.id), params: { assoc_test: assoc_test_params }

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not destroy assoc_test' do
      objects_count = assoc_test.class.count
      delete assoc_test_url(id: assoc_test.id)

      expect(AssocTest.count).to eql(objects_count)
      expect(response).to have_http_status(:forbidden)
    end

    it 'can not destroy selections' do
      create(:assoc_test, assoc_test_params)
      objects_count = assoc_test.class.count

      delete destroy_selections_assoc_tests_url, params: {
        selections: ActiveSupport::JSON.encode([{ data: { id: assoc_test.id }}])
      }

      expect(AssocTest.count).to eq(objects_count)
      expect(response).to have_http_status(:forbidden)
    end
  end

  context 'when logged in as super admin' do
    before do
      sign_in super_admin
    end

    it 'can get index' do
      get assoc_tests_url

      expect(response).to have_http_status(:success)
    end

    it 'can get search' do
      get search_assoc_tests_url

      expect(response).to have_http_status(:success)
    end

    it 'can search' do
      post search_assoc_tests_url

      expect(response).to have_http_status(:success)
    end

    it 'can show assoc_test' do
      get assoc_test_url(id: assoc_test.id)

      expect(response).to have_http_status(:success)
    end

    it 'can get new' do
      get new_assoc_test_url

      expect(response).to have_http_status(:success)
    end

    it 'can create assoc_test' do
      post assoc_tests_url, params: { assoc_test: assoc_test_params }
      created_object = AssocTest.last

      expect(AssocTest.count).to eq(1)
      expect(response).to redirect_to(assoc_test_path(created_object))
    end

    it 'can get edit' do
      get edit_assoc_test_url(id: assoc_test.id)

      expect(response).to have_http_status(:success)
    end

    it 'can update assoc_test' do
      patch assoc_test_url(id: assoc_test.id), params: { assoc_test: assoc_test_params }

      expect(response).to redirect_to(assoc_test_path(assoc_test))
    end

    it 'can destroy assoc_test' do
      objects_count = assoc_test.class.count

      delete assoc_test_url(id: assoc_test.id)

      expect(AssocTest.count).to eql(objects_count - 1)
      expect(response).to redirect_to(assoc_tests_url)
    end

    it 'can destroy selections' do
      create(:assoc_test, assoc_test_params)
      objects_count = assoc_test.class.count

      delete destroy_selections_assoc_tests_url, params: {
        selections: ActiveSupport::JSON.encode([{ data: { id: assoc_test.id }}])
      }

      expect(AssocTest.count).to eq(objects_count - 1)
      expect(response).to have_http_status(:success)
    end
  end
end
