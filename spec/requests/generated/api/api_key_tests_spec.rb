# frozen_string_literal: true

require 'rails_helper'

# Spec for testing the access for the actions in ApiKeyTests API.
# Testing whether a non looged in user can not get any action, because the access should be denied.
# Testing whether some logged in user can get the actions, because the access is granted.
RSpec.describe 'api_key_tests', type: :request do
  let(:default_headers) { { ACCEPT: 'application/json', 'api-version': API_VERSION } }

  # Test data
  let(:api_key_test) { create(:api_key_test) }
  let(:api_key_test_params) { attributes_for(:api_key_test) }

  # api key
  let(:api_key) { create(:eor_api_key) }
  let(:auth_headers) do
    auth_header_data = api_key_header_info(api_key)

    default_headers.merge({
                            'api-key': auth_header_data[:api_key]
                          })
  end

  context 'when using no api key' do
    it 'can not get index' do
      get api_api_key_tests_url, headers: default_headers

      expect(response).to have_http_status(:unauthorized)
    end

    it 'can not search' do
      post search_api_api_key_tests_url,
           params: { filter: { field: 'id', operator: 'eq', value: api_key_test.id } },
           headers: default_headers

      expect(response).to have_http_status(:unauthorized)
    end

    it 'can not show api_key_test' do
      get api_api_key_test_url(id: api_key_test.id), headers: default_headers

      expect(response).to have_http_status(:unauthorized)
    end

    it 'can not create' do
      records_count = ApiKeyTest.count

      post api_api_key_tests_url,
           params: { api_key_test: api_key_test_params },
           headers: default_headers

      expect(response).to have_http_status(:unauthorized)
      expect(ApiKeyTest.count).to eq(records_count)
    end

    it 'can not update api_key_test' do
      patch api_api_key_test_url(id: api_key_test.id),
            params: { api_key_test: api_key_test_params },
            headers: default_headers

      expect(response).to have_http_status(:unauthorized)
    end

    it 'can not destroy api_key_test' do
      records_count = api_key_test.class.count
      delete api_api_key_test_url(id: api_key_test.id), headers: default_headers

      expect(response).to have_http_status(:unauthorized)
      expect(ApiKeyTest.count).to eql(records_count)
    end
  end

  context 'when using an invalid api key' do
    it 'can not get index' do
      get api_api_key_tests_url, headers: auth_headers.merge('api-key': 'invalid')

      expect(response).to have_http_status(:unauthorized)
    end

    it 'can not search' do
      post search_api_api_key_tests_url,
           params: { filter: { field: 'id', operator: 'eq', value: api_key_test.id } },
           headers: auth_headers.merge('api-key': 'invalid')

      expect(response).to have_http_status(:unauthorized)
    end

    it 'can not show api_key_test' do
      get api_api_key_test_url(id: api_key_test.id), headers: auth_headers.merge('api-key': 'invalid')

      expect(response).to have_http_status(:unauthorized)
    end

    it 'can not create' do
      records_count = ApiKeyTest.count

      post api_api_key_tests_url,
           params: { api_key_test: api_key_test_params },
           headers: auth_headers.merge('api-key': 'invalid')

      expect(response).to have_http_status(:unauthorized)
      expect(ApiKeyTest.count).to eq(records_count)
    end

    it 'can not update api_key_test' do
      patch api_api_key_test_url(id: api_key_test.id),
            params: { api_key_test: api_key_test_params },
            headers: auth_headers.merge('api-key': 'invalid')

      expect(response).to have_http_status(:unauthorized)
    end

    it 'can not destroy api_key_test' do
      records_count = api_key_test.class.count
      delete api_api_key_test_url(id: api_key_test.id), headers: auth_headers.merge('api-key': 'invalid')

      expect(response).to have_http_status(:unauthorized)
      expect(ApiKeyTest.count).to eql(records_count)
    end
  end

  context 'when using a valid api key' do
    it 'can get index' do
      api_key_test

      get api_api_key_tests_url, headers: auth_headers

      response_body = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(response_body).to eq(json_from_view('api_key_tests/_api_key_tests', {
                                                   api_key_tests: [api_key_test]
                                                 }))
    end

    context 'when request search' do
      it 'only returns filtered results' do
        create(:api_key_test)
        api_key_test

        post search_api_api_key_tests_url,
             params: { filter: { field: 'id', operator: 'eq', value: api_key_test.id } },
             headers: auth_headers

        response_body = response.parsed_body

        expect(response).to have_http_status(:success)
        expect(response_body['results']).to eq(
          json_from_view('api_key_tests/_api_key_tests', {
                           api_key_tests: [api_key_test]
                         })
        )
      end

      it 'only returns results for specified page' do
        create(:api_key_test)
        api_key_test

        post search_api_api_key_tests_url,
             params: { page: 1, page_size: 1 },
             headers: auth_headers

        response_body = response.parsed_body

        expect(response).to have_http_status(:success)
        expect(response_body['results']).to eq(
          json_from_view('api_key_tests/_api_key_tests', {
                           api_key_tests: [api_key_test]
                         })
        )
        expect(response_body['pages_count']).to eq(2)
      end

      it 'returns results with specified order and order_direction' do
        second_record = create(:api_key_test)
        api_key_test

        post search_api_api_key_tests_url,
             params: { order: 'created_at', order_direction: 'desc' },
             headers: auth_headers

        response_body = response.parsed_body

        expect(response).to have_http_status(:success)
        expect(response_body['results']).to eq(
          json_from_view('api_key_tests/_api_key_tests', {
                           api_key_tests: [api_key_test, second_record]
                         })
        )
      end
    end

    it 'can show api_key_test' do
      get api_api_key_test_url(id: api_key_test.id), headers: auth_headers

      response_body = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(response_body).to eq(json_from_view('api_key_tests/_api_key_test', {
                                                   api_key_test: api_key_test
                                                 }))
    end

    it 'can create api_key_test' do
      records_count = ApiKeyTest.count

      post api_api_key_tests_url,
           params: { api_key_test: api_key_test_params },
           headers: auth_headers
      created_object = ApiKeyTest.last

      response_body = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(ApiKeyTest.count).to eq(records_count + 1)
      expect(response_body).to eq(json_from_view('api_key_tests/_api_key_test', {
                                                   api_key_test: created_object
                                                 }))
    end

    it 'can update api_key_test' do
      patch api_api_key_test_url(id: api_key_test.id),
            params: { api_key_test: api_key_test_params },
            headers: auth_headers

      response_body = response.parsed_body
      api_key_test.reload

      expect(response).to have_http_status(:success)
      expect(response_body).to eq(json_from_view('api_key_tests/_api_key_test', {
                                                   api_key_test: api_key_test
                                                 }))
    end

    it 'can destroy api_key_test' do
      records_count = api_key_test.class.count

      delete api_api_key_test_url(id: api_key_test.id), headers: auth_headers

      expect(response).to have_http_status(:success)
      expect(ApiKeyTest.count).to eql(records_count - 1)
    end
  end
end
