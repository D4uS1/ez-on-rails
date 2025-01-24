# frozen_string_literal: true

require 'rails_helper'

# Spec for testing some actions of the resource controller.
# Exemplarily done with ValidationErrorTestController.
RSpec.describe 'EzOnRails::ResourceController' do
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

  context 'when requesting search' do
    let(:record_one) { create(:validation_error_test, name: 'B', number: 1) }
    let(:record_two) { create(:validation_error_test, name: 'A', number: 1) }

    before do
      record_one
      record_two
    end

    it 'returns all for no filters' do
      post search_api_validation_error_tests_path,
           headers: auth_headers_admin,
           params: { filter: nil }

      response_body = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(response_body['results'].length).to eq(2)
      expect(response_body['results']).to eq(json_from_view('validation_error_tests/_validation_error_tests', {
                                                              validation_error_tests: [record_one, record_two]
                                                            }))
    end

    it 'returns filtered items with search_filter' do
      post search_api_validation_error_tests_path,
           headers: auth_headers_admin,
           params: { filter: { field: 'id', operator: 'eq', value: record_two.id } }

      response_body = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(response_body['results'].length).to eq(1)
      expect(response_body['results']).to eq(json_from_view('validation_error_tests/_validation_error_tests', {
                                                              validation_error_tests: [record_two]
                                                            }))
    end

    it 'returns filtered items with search_filter_composition' do
      post search_api_validation_error_tests_path,
           headers: auth_headers_admin,
           params: {
             filter: {
               logic: 'and',
               filters: [
                 { field: 'id', operator: 'eq', value: record_one.id },
                 { field: 'number', operator: 'eq', value: 1 }
               ]
             }
           }

      response_body = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(response_body['results'].length).to eq(1)
      expect(response_body['results']).to eq(json_from_view('validation_error_tests/_validation_error_tests', {
                                                              validation_error_tests: [record_one]
                                                            }))
    end

    it 'returns items for specified page' do
      post search_api_validation_error_tests_path,
           headers: auth_headers_admin,
           params: { page: 1, page_size: 1 }

      response_body = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(response_body['results'].length).to eq(1)
      expect(response_body['results']).to eq(json_from_view('validation_error_tests/_validation_error_tests', {
                                                              validation_error_tests: [record_two]
                                                            }))
    end

    it 'returns correct pages_count if page and page_size is specified' do
      create(:validation_error_test, name: 'Three', number: 1)

      post search_api_validation_error_tests_path,
           headers: auth_headers_admin,
           params: { page: 1, page_size: 2 }

      response_body = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(response_body['pages_count']).to eq(2)
    end

    it 'returns items with specified order' do
      post search_api_validation_error_tests_path,
           headers: auth_headers_admin,
           params: { order: 'created_at', order_direction: 'desc' }

      response_body = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(response_body['results'][0]['id']).to eq(record_two.id)
      expect(response_body['results'][1]['id']).to eq(record_one.id)
    end

    it 'orders items by id asc if no order is specified' do
      post search_api_validation_error_tests_path,
           headers: auth_headers_admin,
           params: {}

      response_body = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(response_body['results'][0]['id']).to eq(record_one.id)
      expect(response_body['results'][1]['id']).to eq(record_two.id)
    end

    it 'returns items with specified filter, order and pagination' do
      create(:validation_error_test, name: 'Three', number: 2)
      record_four = create(:validation_error_test, name: 'Four', number: 1)

      post search_api_validation_error_tests_path,
           headers: auth_headers_admin,
           params: {
             page: 0,
             page_size: 2,
             order: 'created_at',
             order_direction: 'desc',
             filter: { field: 'number', operator: 'eq', value: 1 }
           }

      response_body = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(response_body['pages_count']).to eq(2)
      expect(response_body['results'].length).to eq(2)
      expect(response_body['results'][0]['id']).to eq(record_four.id)
      expect(response_body['results'][1]['id']).to eq(record_two.id)
      expect(response_body['results']).to eq(json_from_view('validation_error_tests/_validation_error_tests', {
                                                              validation_error_tests: [record_four, record_two]
                                                            }))
    end
  end
end
