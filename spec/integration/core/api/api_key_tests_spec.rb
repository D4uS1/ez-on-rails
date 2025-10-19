# frozen_string_literal: true

require 'swagger_helper'

# Returns the properties of the ApiKeysTest Resource.
# This is needed because the spec was generated in the dummy app, hence the properties
# are not delivered here, because they are not defined in the correct swagger_helper.
def api_keys_test_properties
  {
    test: {
      type: :string
    }
  }
end

describe 'ApiKeyTests API' do
  let(:api_key) { create(:eor_api_key) }
  let(:auth_header_info) { api_key_header_info(api_key) }
  let(:expired_api_key) { create(:eor_api_key, expires_at: 1.day.ago) }
  let(:expired_auth_header_info) { api_key_header_info(expired_api_key) }
  let(:api_key_test_attributes) { attributes_for(:api_key_test) }
  let(:api_key_test_obj) { create(:api_key_test) }
  let(:api_key_test_param) { api_key_test_attributes }

  # GET index action
  path '/api/api_key_tests' do
    get 'Retrieves all api_key_tests' do
      tags 'ApiKeyTests'
      security [{ api_key: [] }]
      produces 'application/json'
      parameter name: :'api-version', in: :header, type: :string, default: API_VERSION

      response '200', 'api_key_tests found' do
        schema type: :array,
               items: {
                 type: :object, properties: api_keys_test_properties.merge(
                   {
                     id: { type: :integer },
                     owner_id: { type: :integer }
                   }
                 )
               }

        let(:'api-key') { auth_header_info[:api_key] }
        let(:'api-version') { API_VERSION }

        run_test!
      end

      response '406', 'unsupported accept header' do
        let(:'api-key') { auth_header_info[:api_key] }
        let(:'api-version') { API_VERSION }
        let(:Accept) { 'application/html' }

        run_test!
      end

      response '410', 'invalid api version' do
        let(:'api-key') { auth_header_info[:api_key] }
        let(:'api-version') { 'invalid' }

        run_test!
      end

      response '410', 'no api version' do
        let(:'api-key') { auth_header_info[:api_key] }
        let(:'api-version') { nil }

        run_test!
      end

      response '401', 'invalid api key' do
        let(:'api-key') { 'invalid' }
        let(:'api-version') { API_VERSION }

        run_test!
      end

      response '401', 'expired api key' do
        let(:'api-key') { expired_auth_header_info[:api_key] }
        let(:'api-version') { API_VERSION }

        run_test!
      end

      response '401', 'no api key' do
        let(:'api-key') { nil }
        let(:'api-version') { API_VERSION }

        run_test!
      end
    end
  end

  # POST search action
  path '/api/api_key_tests/search' do
    post 'Searches for api_key_tests' do
      tags 'ApiKeyTests'
      security [{ api_key: [] }]
      produces 'application/json'
      consumes 'application/json'
      parameter name: :'api-version', in: :header, type: :string, default: API_VERSION
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          filter: {
            oneOf: [
              { '$ref' => '#/components/schemas/SearchFilter' },
              { '$ref' => '#/components/schemas/SearchFilterComposition' },
              { type: 'null' }
            ]
          },
          page: { type: :integer, nullable: true },
          page_size: { type: :integer, nullable: true },
          order: { type: :string, nullable: true },
          order_direction: { type: :string, enum: %w[asc desc], nullable: true }
        }
      }

      response '200', 'api_key_tests found' do
        schema type: :object,
               properties: {
                 results: {
                   type: :array,
                   items: { type: :object, properties: api_keys_test_properties }
                 },
                 pages_count: { type: :integer, nullable: true }
               }

        let(:'api-key') { auth_header_info[:api_key] }
        let(:'api-version') { API_VERSION }
        let(:params) do
          {
            filter: { field: 'id', operator: 'eq', value: api_key_test_obj.id },
            page: 0,
            page_size: 10,
            order: 'created_at',
            order_direction: 'desc'
          }
        end

        run_test!
      end

      response '406', 'unsupported accept header' do
        let(:'api-key') { auth_header_info[:api_key] }
        let(:'api-version') { API_VERSION }
        let(:Accept) { 'application/html' }
        let(:params) do
          {
            filter: { field: 'id', operator: 'eq', value: api_key_test_obj.id },
            page: 0,
            page_size: 10,
            order: 'created_at',
            order_direction: 'desc'
          }
        end

        run_test!
      end

      response '410', 'invalid api version' do
        let(:'api-key') { auth_header_info[:api_key] }
        let(:'api-version') { 'invalid' }
        let(:params) do
          {
            filter: { field: 'id', operator: 'eq', value: api_key_test_obj.id },
            page: 0,
            page_size: 10,
            order: 'created_at',
            order_direction: 'desc'
          }
        end

        run_test!
      end

      response '410', 'no api version' do
        let(:'api-key') { auth_header_info[:api_key] }
        let(:'api-version') { nil }
        let(:params) do
          {
            filter: { field: 'id', operator: 'eq', value: api_key_test_obj.id },
            page: 0,
            page_size: 10,
            order: 'created_at',
            order_direction: 'desc'
          }
        end

        run_test!
      end

      response '401', 'invalid api key' do
        let(:'api-key') { 'invalid' }
        let(:'api-version') { API_VERSION }
        let(:params) do
          {
            filter: { field: 'id', operator: 'eq', value: api_key_test_obj.id },
            page: 0,
            page_size: 10,
            order: 'created_at',
            order_direction: 'desc'
          }
        end

        run_test!
      end

      response '401', 'no api key' do
        let(:'api-key') { nil }
        let(:'api-version') { API_VERSION }
        let(:params) do
          {
            filter: { field: 'id', operator: 'eq', value: api_key_test_obj.id },
            page: 0,
            page_size: 10,
            order: 'created_at',
            order_direction: 'desc'
          }
        end

        run_test!
      end

      response '401', 'expired api key' do
        let(:'api-key') { expired_auth_header_info[:api_key] }
        let(:'api-version') { API_VERSION }
        let(:params) do
          {
            filter: { field: 'id', operator: 'eq', value: api_key_test_obj.id },
            page: 0,
            page_size: 10,
            order: 'created_at',
            order_direction: 'desc'
          }
        end

        run_test!
      end
    end
  end

  # GET show action
  path '/api/api_key_tests/{id}' do
    get 'Retrieves a api_key_test' do
      tags 'ApiKeyTests'
      security [{ api_key: [] }]
      produces 'application/json'
      parameter name: :'api-version', in: :header, type: :string, default: API_VERSION
      parameter name: :id, in: :path, type: :integer

      response '200', 'api_key_test found' do
        schema type: :object,
               properties: api_keys_test_properties.merge({
                                                            id: { type: :integer },
                                                            owner_id: { type: :integer }
                                                          })

        let(:'api-key') { auth_header_info[:api_key] }
        let(:'api-version') { API_VERSION }
        let(:id) { api_key_test_obj.id }

        run_test!
      end

      response '404', 'api_key_test not found' do
        let(:'api-key') { auth_header_info[:api_key] }
        let(:'api-version') { API_VERSION }
        let(:id) { 'invalid' }

        run_test!
      end

      response '406', 'unsupported accept header' do
        let(:'api-key') { auth_header_info[:api_key] }
        let(:'api-version') { API_VERSION }
        let(:id) { api_key_test_obj.id }
        let(:Accept) { 'application/html' }

        run_test!
      end

      response '410', 'invalid api version' do
        let(:'api-key') { auth_header_info[:api_key] }
        let(:'api-version') { 'invalid' }
        let(:id) { api_key_test_obj.id }

        run_test!
      end

      response '410', 'no api version' do
        let(:'api-key') { auth_header_info[:api_key] }
        let(:'api-version') { nil }
        let(:id) { api_key_test_obj.id }

        run_test!
      end

      response '401', 'invalid api key' do
        let(:'api-key') { 'invalid' }
        let(:'api-version') { API_VERSION }
        let(:id) { api_key_test_obj.id }

        run_test!
      end

      response '401', 'no api key' do
        let(:'api-key') { nil }
        let(:'api-version') { API_VERSION }
        let(:id) { api_key_test_obj.id }

        run_test!
      end

      response '401', 'expired api key' do
        let(:'api-key') { expired_auth_header_info[:api_key] }
        let(:'api-version') { API_VERSION }
        let(:id) { api_key_test_obj.id }

        run_test!
      end
    end
  end

  # POST create action
  path '/api/api_key_tests' do
    post 'Creates a api_key_test' do
      tags 'ApiKeyTests'
      security [{ api_key: [] }]
      consumes 'application/json'
      produces 'application/json'
      parameter name: :'api-version', in: :header, type: :string, default: API_VERSION
      parameter name: :api_key_test,
                in: :body,
                schema: { type: :object, properties: api_keys_test_properties }

      response '201', 'api_key_test created' do
        schema type: :object,
               properties: api_keys_test_properties.merge({
                                                            id: { type: :integer },
                                                            owner_id: { type: :integer }
                                                          })

        let(:'api-key') { auth_header_info[:api_key] }
        let(:'api-version') { API_VERSION }
        let(:api_key_test) { api_key_test_param }

        run_test!
      end

      response '406', 'unsupported accept header' do
        let(:'api-key') { auth_header_info[:api_key] }
        let(:'api-version') { API_VERSION }
        let(:Accept) { 'application/html' }
        let(:api_key_test) { api_key_test_param }

        run_test!
      end

      response '410', 'invalid api version' do
        let(:'api-key') { auth_header_info[:api_key] }
        let(:'api-version') { 'invalid' }
        let(:api_key_test) { api_key_test_param }

        run_test!
      end

      response '410', 'no api version' do
        let(:'api-key') { auth_header_info[:api_key] }
        let(:'api-version') { nil }
        let(:api_key_test) { api_key_test_param }

        run_test!
      end

      response '401', 'invalid api key' do
        let(:'api-key') { 'invalid' }
        let(:'api-version') { API_VERSION }
        let(:api_key_test) { api_key_test_param }

        run_test!
      end

      response '401', 'no api key' do
        let(:'api-key') { nil }
        let(:'api-version') { API_VERSION }
        let(:api_key_test) { api_key_test_param }

        run_test!
      end

      response '401', 'expired api key' do
        let(:'api-key') { expired_auth_header_info[:api_key] }
        let(:'api-version') { API_VERSION }
        let(:api_key_test) { api_key_test_param }

        run_test!
      end
    end
  end

  # PATCH update action
  path '/api/api_key_tests/{id}' do
    patch 'Updates a api_key_test' do
      tags 'ApiKeyTests'
      security [{ api_key: [] }]
      consumes 'application/json'
      produces 'application/json'
      parameter name: :'api-version', in: :header, type: :string, default: API_VERSION
      parameter name: :id, in: :path, type: :integer
      parameter name: :api_key_test,
                in: :body,
                schema: { '$ref' => '#/components/schemas/ApiKeyTestProperties' }

      response '200', 'api_key_test updated' do
        schema type: :object, properties: api_keys_test_properties.merge({
                                                                           id: { type: :integer },
                                                                           owner_id: { type: :integer }
                                                                         })

        let(:'api-key') { auth_header_info[:api_key] }
        let(:'api-version') { API_VERSION }
        let(:id) { api_key_test_obj.id }
        let(:api_key_test) { api_key_test_param }

        run_test!
      end

      response '406', 'unsupported accept header' do
        let(:'api-key') { auth_header_info[:api_key] }
        let(:'api-version') { API_VERSION }
        let(:id) { api_key_test_obj.id }
        let(:api_key_test) { api_key_test_param }
        let(:Accept) { 'application/html' }

        run_test!
      end

      response '410', 'invalid api version' do
        let(:'api-key') { auth_header_info[:api_key] }
        let(:'api-version') { 'invalid' }
        let(:id) { api_key_test_obj.id }
        let(:api_key_test) { api_key_test_param }

        run_test!
      end

      response '410', 'no api version' do
        let(:'api-key') { auth_header_info[:api_key] }
        let(:'api-version') { nil }
        let(:id) { api_key_test_obj.id }
        let(:api_key_test) { api_key_test_param }

        run_test!
      end

      response '401', 'invalid api key' do
        let(:'api-key') { 'invalid' }
        let(:'api-version') { API_VERSION }
        let(:id) { api_key_test_obj.id }
        let(:api_key_test) { api_key_test_param }

        run_test!
      end

      response '401', 'no api key' do
        let(:'api-key') { nil }
        let(:'api-version') { API_VERSION }
        let(:id) { api_key_test_obj.id }
        let(:api_key_test) { api_key_test_param }

        run_test!
      end

      response '401', 'expired api key' do
        let(:'api-key') { expired_auth_header_info[:api_key] }
        let(:'api-version') { API_VERSION }
        let(:id) { api_key_test_obj.id }
        let(:api_key_test) { api_key_test_param }

        run_test!
      end
    end
  end

  # DELETE destroy action
  path '/api/api_key_tests/{id}' do
    delete 'Destroys a ApiKeyTest' do
      tags 'ApiKeyTests'
      security [{ api_key: [] }]
      consumes 'application/json'
      produces 'application/json'
      parameter name: :'api-version', in: :header, type: :string, default: API_VERSION
      parameter name: :id, in: :path, type: :integer

      response '204', 'api_key_test destroyed' do
        let(:'api-key') { auth_header_info[:api_key] }
        let(:'api-version') { API_VERSION }
        let(:id) { api_key_test_obj.id }

        run_test!
      end

      response '406', 'unsupported accept header' do
        let(:'api-key') { auth_header_info[:api_key] }
        let(:'api-version') { API_VERSION }
        let(:Accept) { 'application/html' }
        let(:id) { api_key_test_obj.id }

        run_test!
      end

      response '410', 'invalid api version' do
        let(:'api-key') { auth_header_info[:api_key] }
        let(:'api-version') { 'invalid' }
        let(:id) { api_key_test_obj.id }

        run_test!
      end

      response '410', 'no api version' do
        let(:'api-key') { auth_header_info[:api_key] }
        let(:'api-version') { nil }
        let(:id) { api_key_test_obj.id }

        run_test!
      end

      response '401', 'invalid api key' do
        let(:'api-key') { 'invalid' }
        let(:'api-version') { API_VERSION }
        let(:id) { api_key_test_obj.id }

        run_test!
      end

      response '401', 'no api key' do
        let(:'api-key') { nil }
        let(:'api-version') { API_VERSION }
        let(:id) { api_key_test_obj.id }

        run_test!
      end

      response '401', 'expired api key' do
        let(:'api-key') { expired_auth_header_info[:api_key] }
        let(:'api-version') { API_VERSION }
        let(:id) { api_key_test_obj.id }

        run_test!
      end
    end
  end
end
