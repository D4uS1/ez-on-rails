# frozen_string_literal: true

require 'rails_helper'

# Spec for testing the access for the actions in JsonSchemaValidatorTests.
# Testing whether a non logged in user can not get any action, because the access should be denied.
# Testing whether some non super admin logged in user (called andrew here) can not get any action,
# because the access should be denied.
# Testing whether some super_admin can get the actions, because the access is granted.
RSpec.describe 'json_schema_validator_tests', type: :request do
  # users
  let(:andrew) { create(:andrew) } # non admin user
  let(:super_admin) { User.super_admin } # super administrator user

  # Test data
  let(:json_schema_validator_test) { create(:json_schema_validator_test) }
  let(:json_schema_validator_test_params) { attributes_for(:json_schema_validator_test) }

  # for test of update, destroy and show actions
  context 'when not logged in' do
    it 'can not get index' do
      get json_schema_validator_tests_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not get search' do
      get search_json_schema_validator_tests_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not search' do
      post search_json_schema_validator_tests_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not show json_schema_validator_test' do
      get json_schema_validator_test_url(id: json_schema_validator_test.id)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not get new' do
      get new_json_schema_validator_test_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not create' do
      post json_schema_validator_tests_url, params: { json_schema_validator_test: json_schema_validator_test_params }

      expect(JsonSchemaValidatorTest.count).to eq(0)
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not get edit' do
      get edit_json_schema_validator_test_url(id: json_schema_validator_test.id)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not update json_schema_validator_test' do
      patch json_schema_validator_test_url(id: json_schema_validator_test.id), params: { json_schema_validator_test: json_schema_validator_test_params }

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not destroy json_schema_validator_test' do
      objects_count = json_schema_validator_test.class.count
      delete json_schema_validator_test_url(id: json_schema_validator_test.id)

      expect(JsonSchemaValidatorTest.count).to eql(objects_count)
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not destroy selections' do
      create(:json_schema_validator_test, json_schema_validator_test_params)
      objects_count = json_schema_validator_test.class.count

      delete destroy_selections_json_schema_validator_tests_url, params: {
        selections: ActiveSupport::JSON.encode([{ data: { id: json_schema_validator_test.id }}])
      }

      expect(JsonSchemaValidatorTest.count).to eq(objects_count)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'when logged in as andrew' do
    before do
      sign_in andrew
    end

    it 'can not get index' do
      get json_schema_validator_tests_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not get search' do
      get search_json_schema_validator_tests_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not search' do
      post search_json_schema_validator_tests_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not show json_schema_validator_test' do
      get json_schema_validator_test_url(id: json_schema_validator_test.id)

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not get new' do
      get new_json_schema_validator_test_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not create' do
      post json_schema_validator_tests_url, params: { json_schema_validator_test: json_schema_validator_test_params }

      expect(JsonSchemaValidatorTest.count).to eq(0)
      expect(response).to have_http_status(:forbidden)
    end

    it 'can not get edit' do
      get edit_json_schema_validator_test_url(id: json_schema_validator_test.id)

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not update json_schema_validator_test' do
      patch json_schema_validator_test_url(id: json_schema_validator_test.id), params: { json_schema_validator_test: json_schema_validator_test_params }

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not destroy json_schema_validator_test' do
      objects_count = json_schema_validator_test.class.count
      delete json_schema_validator_test_url(id: json_schema_validator_test.id)

      expect(JsonSchemaValidatorTest.count).to eql(objects_count)
      expect(response).to have_http_status(:forbidden)
    end

    it 'can not destroy selections' do
      create(:json_schema_validator_test, json_schema_validator_test_params)
      objects_count = json_schema_validator_test.class.count

      delete destroy_selections_json_schema_validator_tests_url, params: {
        selections: ActiveSupport::JSON.encode([{ data: { id: json_schema_validator_test.id }}])
      }

      expect(JsonSchemaValidatorTest.count).to eq(objects_count)
      expect(response).to have_http_status(:forbidden)
    end
  end

  context 'when logged in as super admin' do
    before do
      sign_in super_admin
    end

    it 'can get index' do
      get json_schema_validator_tests_url

      expect(response).to have_http_status(:success)
    end

    it 'can get search' do
      get search_json_schema_validator_tests_url

      expect(response).to have_http_status(:success)
    end

    it 'can search' do
      post search_json_schema_validator_tests_url

      expect(response).to have_http_status(:success)
    end

    it 'can show json_schema_validator_test' do
      get json_schema_validator_test_url(id: json_schema_validator_test.id)

      expect(response).to have_http_status(:success)
    end

    it 'can get new' do
      get new_json_schema_validator_test_url

      expect(response).to have_http_status(:success)
    end

    it 'can create json_schema_validator_test' do
      post json_schema_validator_tests_url, params: { json_schema_validator_test: json_schema_validator_test_params }
      created_object = JsonSchemaValidatorTest.last

      expect(JsonSchemaValidatorTest.count).to eq(1)
      expect(response).to redirect_to(json_schema_validator_test_path(created_object))
    end

    it 'can get edit' do
      get edit_json_schema_validator_test_url(id: json_schema_validator_test.id)

      expect(response).to have_http_status(:success)
    end

    it 'can update json_schema_validator_test' do
      patch json_schema_validator_test_url(id: json_schema_validator_test.id), params: { json_schema_validator_test: json_schema_validator_test_params }

      expect(response).to redirect_to(json_schema_validator_test_path(json_schema_validator_test))
    end

    it 'can destroy json_schema_validator_test' do
      objects_count = json_schema_validator_test.class.count

      delete json_schema_validator_test_url(id: json_schema_validator_test.id)

      expect(JsonSchemaValidatorTest.count).to eql(objects_count - 1)
      expect(response).to redirect_to(json_schema_validator_tests_url)
    end

    it 'can destroy selections' do
      create(:json_schema_validator_test, json_schema_validator_test_params)
      objects_count = json_schema_validator_test.class.count

      delete destroy_selections_json_schema_validator_tests_url, params: {
        selections: ActiveSupport::JSON.encode([{ data: { id: json_schema_validator_test.id }}])
      }

      expect(JsonSchemaValidatorTest.count).to eq(objects_count - 1)
      expect(response).to have_http_status(:success)
    end
  end
end
