# frozen_string_literal: true

require 'rails_helper'

# Spec for testing the access for the actions in PropertiesTests.
# Testing whether a non looged in user can not get any action, because the access should be denied.
# Testing whether some non super admin logged in user (called andrew here) can not get any action,
# because the access should be denied.
# Testing whether some super_admin can get the actions, because the access is granted.
RSpec.describe 'PropertiesTests' do
  # users
  let(:andrew) { create(:andrew) } # non admin user
  let(:super_admin) { User.super_admin } # super administrator user

  # Test data
  let(:properties_test) { create(:properties_test) }
  let(:properties_test_params) do
    attributes_for(
      :properties_test,
      assoc_test_id: create(:assoc_test).id
    )
  end

  # for test of update, destroy and show actions
  context 'when not logged in' do
    it 'can not get index' do
      get properties_tests_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not get search' do
      get search_properties_tests_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not search' do
      post search_properties_tests_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not show properties_test' do
      get properties_test_url(id: properties_test.id)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not get new' do
      get new_properties_test_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not create' do
      post properties_tests_url, params: { properties_test: properties_test_params }

      expect(PropertiesTest.count).to eq(0)
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not get edit' do
      get edit_properties_test_url(id: properties_test.id)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not update properties_test' do
      patch properties_test_url(id: properties_test.id), params: { properties_test: properties_test_params }

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not destroy properties_test' do
      objects_count = properties_test.class.count
      delete properties_test_url(id: properties_test.id)

      expect(PropertiesTest.count).to eql(objects_count)
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not destroy selections' do
      create(:properties_test, properties_test_params)
      objects_count = properties_test.class.count

      delete destroy_selections_properties_tests_url, params: {
        selections: ActiveSupport::JSON.encode([{ data: { id: properties_test.id } }])
      }

      expect(PropertiesTest.count).to eq(objects_count)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'when logged in as andrew' do
    before do
      sign_in andrew
    end

    it 'can not get index' do
      get properties_tests_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not get search' do
      get search_properties_tests_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not search' do
      post search_properties_tests_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not show properties_test' do
      get properties_test_url(id: properties_test.id)

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not get new' do
      get new_properties_test_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not create' do
      post properties_tests_url, params: { properties_test: properties_test_params }

      expect(PropertiesTest.count).to eq(0)
      expect(response).to have_http_status(:forbidden)
    end

    it 'can not get edit' do
      get edit_properties_test_url(id: properties_test.id)

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not update properties_test' do
      patch properties_test_url(id: properties_test.id), params: { properties_test: properties_test_params }

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not destroy properties_test' do
      objects_count = properties_test.class.count
      delete properties_test_url(id: properties_test.id)

      expect(PropertiesTest.count).to eql(objects_count)
      expect(response).to have_http_status(:forbidden)
    end

    it 'can not destroy selections' do
      create(:properties_test, properties_test_params)
      objects_count = properties_test.class.count

      delete destroy_selections_properties_tests_url, params: {
        selections: ActiveSupport::JSON.encode([{ data: { id: properties_test.id } }])
      }

      expect(PropertiesTest.count).to eq(objects_count)
      expect(response).to have_http_status(:forbidden)
    end
  end

  context 'when logged in as super admin' do
    before do
      sign_in super_admin
    end

    it 'can get index' do
      get properties_tests_url

      expect(response).to have_http_status(:success)
    end

    it 'can get search' do
      get search_properties_tests_url

      expect(response).to have_http_status(:success)
    end

    it 'can search' do
      post search_properties_tests_url

      expect(response).to have_http_status(:success)
    end

    it 'can show properties_test' do
      get properties_test_url(id: properties_test.id)

      expect(response).to have_http_status(:success)
    end

    it 'can get new' do
      get new_properties_test_url

      expect(response).to have_http_status(:success)
    end

    it 'can create properties_test' do
      post properties_tests_url, params: { properties_test: properties_test_params }
      created_object = PropertiesTest.last

      expect(PropertiesTest.count).to eq(1)
      expect(response).to redirect_to(properties_test_path(created_object))
    end

    it 'can get edit' do
      get edit_properties_test_url(id: properties_test.id)

      expect(response).to have_http_status(:success)
    end

    it 'can update properties_test' do
      patch properties_test_url(id: properties_test.id), params: { properties_test: properties_test_params }

      expect(response).to redirect_to(properties_test_path(properties_test))
    end

    it 'can destroy properties_test' do
      objects_count = properties_test.class.count

      delete properties_test_url(id: properties_test.id)

      expect(PropertiesTest.count).to eql(objects_count - 1)
      expect(response).to redirect_to(properties_tests_url)
    end

    it 'can destroy selections' do
      create(:properties_test, properties_test_params)
      objects_count = properties_test.class.count

      delete destroy_selections_properties_tests_url, params: {
        selections: ActiveSupport::JSON.encode([{ data: { id: properties_test.id } }])
      }

      expect(PropertiesTest.count).to eq(objects_count - 1)
      expect(response).to have_http_status(:success)
    end
  end
end
