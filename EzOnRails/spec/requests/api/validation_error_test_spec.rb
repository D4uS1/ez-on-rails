# frozen_string_literal: true

require 'rails_helper'

# Spec for testing that some validation error occurs on update or create or destroy actions.
RSpec.describe 'Api::ValidationErrorTestsController' do
  # users
  let(:admin) { User.super_admin }
  let(:default_headers) { { ACCEPT: 'application/json', 'api-version': API_VERSION } }
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
  let(:valid_params) { { validation_error_test: attributes_for(:validation_error_test) } }
  let(:invalid_params) do
    {
      validation_error_test: attributes_for(:validation_error_test).merge({ name: nil, number: nil })
    }
  end
  let(:validation_error_test_obj) { create(:validation_error_test) }

  context 'when creating' do
    it 'receives validation errors' do
      objs_count = ValidationErrorTest.count

      post api_validation_error_tests_path,
           headers: auth_headers_admin,
           params: invalid_params

      response_body = response.parsed_body

      expect(response).to have_http_status(:unprocessable_entity)
      expect(ValidationErrorTest.count).to eq(objs_count)
      expect(response_body['error']).to include('validation failed:')
      expect(response_body['error']).to include('name')
      expect(response_body['error']).to include('number')
    end

    it 'creates if valid' do
      objs_count = ValidationErrorTest.count

      post api_validation_error_tests_path,
           headers: auth_headers_admin,
           params: valid_params

      response_body = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(ValidationErrorTest.count).to eq(objs_count + 1)
      expect(response_body).to eq(
        json_from_view('validation_error_tests/_validation_error_test',
                       {
                         validation_error_test: ValidationErrorTest.last
                       })
      )
    end
  end

  context 'when updating' do
    it 'receives validation errors' do
      put api_validation_error_test_path(validation_error_test_obj),
          headers: auth_headers_admin,
          params: invalid_params

      response_body = response.parsed_body

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body['error']).to include('validation failed:')
      expect(response_body['error']).to include('name')
      expect(response_body['error']).to include('number')
    end

    it 'updates if valid' do
      put api_validation_error_test_path(validation_error_test_obj),
          headers: auth_headers_admin,
          params: valid_params

      response_body = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(response_body).to eq(
        json_from_view('validation_error_tests/_validation_error_test',
                       {
                         validation_error_test: ValidationErrorTest.last
                       })
      )
    end
  end

  context 'when destroying' do
    it 'receives validation errors' do
      validation_error_test_obj.update(name: 'dont_destroy')

      delete api_validation_error_test_path(validation_error_test_obj),
             headers: auth_headers_admin,
             params: valid_params

      response_body = response.parsed_body

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body['error']).to include('validation failed:')
      expect(response_body['error']).to include('name')
    end

    it 'destroys if valid' do
      objs_count = validation_error_test_obj.class.count

      delete api_validation_error_test_path(validation_error_test_obj),
             headers: auth_headers_admin,
             params: valid_params

      expect(response).to have_http_status(:success)
      expect(ValidationErrorTest.count).to eq(objs_count - 1)
    end
  end

  context 'when requesting index' do
    it 'shows all records' do
      validation_error_test_obj

      get api_validation_error_tests_path,
          headers: auth_headers_admin

      response_body = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(response_body.length).to eq(1)
      expect(response_body).to include(
        json_from_view('validation_error_tests/_validation_error_test',
                       {
                         validation_error_test: ValidationErrorTest.last
                       })
      )
    end

    it 'orders by overwritten default order' do
      record_b = create(:validation_error_test, name: 'B')
      record_c = create(:validation_error_test, name: 'C')
      record_a = create(:validation_error_test, name: 'A')

      get api_validation_error_tests_path,
          headers: auth_headers_admin

      response_body = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(response_body.length).to eq(3)
      expect(response_body[0]['id']).to eq(record_c.id)
      expect(response_body[1]['id']).to eq(record_b.id)
      expect(response_body[2]['id']).to eq(record_a.id)
    end
  end

  context 'when requesting search' do
    it 'searches records' do
      post search_api_validation_error_tests_path,
           headers: auth_headers_admin, params: {
             validation_error_test: {
               mame: validation_error_test_obj.name
             }
           }

      response_body = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(response_body['results'].length).to eq(1)
      expect(response_body['results']).to include(
        json_from_view('validation_error_tests/_validation_error_test',
                       {
                         validation_error_test: ValidationErrorTest.last
                       })
      )
    end

    it 'orders by overwritten default_order if no order is specified' do
      record_b = create(:validation_error_test, name: 'B')
      record_c = create(:validation_error_test, name: 'C')
      record_a = create(:validation_error_test, name: 'A')

      post search_api_validation_error_tests_path,
           headers: auth_headers_admin

      response_body = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(response_body['results'].length).to eq(3)
      expect(response_body['results'][0]['id']).to eq(record_c.id)
      expect(response_body['results'][1]['id']).to eq(record_b.id)
      expect(response_body['results'][2]['id']).to eq(record_a.id)
    end
  end

  context 'when requesting show' do
    it 'shows the record' do
      get api_validation_error_test_path(validation_error_test_obj),
          headers: auth_headers_admin

      response_body = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(response_body).to eq(
        json_from_view('validation_error_tests/_validation_error_test',
                       {
                         validation_error_test: ValidationErrorTest.last
                       })
      )
    end
  end
end
