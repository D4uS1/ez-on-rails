# frozen_string_literal: true

require 'swagger_helper'

# Returns the properties of the OauthClientAccessTest Resource.
# This is needed because the rswag dsl does not support let for defining purposes.
def oauth_client_access_test_properties
  {
    test: {
      type: :string
    }
  }
end

describe 'OauthClientAccessTest API' do
  let(:oauth_client_access_test_attributes) { attributes_for(:oauth_client_access_test) }
  let(:oauth_client_access_test_obj) { create(:oauth_client_access_test) }
  let(:oauth_client_access_test_param) { { oauth_client_access_test: oauth_client_access_test_attributes } }
  let(:andrew) { create(:andrew) }
  let(:auth_headers) { authorization_header_info(andrew) }

  before do
    # restrict access to controllers path
    group = create(:testgroup)
    create(:eor_group_access, group:,  namespace: 'api', controller: 'oauth_client_access_tests')
    create(:eor_user_group_assignment, user: andrew, group:)
  end

  # GET index action
  path '/api/oauth_client_access_tests' do
    get 'Retrieves all oauth_client_access_tests' do
      tags 'OauthClientAccessTests'
      parameter name: :uid, in: :header, type: :string
      parameter name: :client, in: :header, type: :string
      parameter name: :'access-token', in: :header, type: :string
      produces 'application/json'
      parameter name: :'api-version', in: :header, type: :string, default: API_VERSION

      response '200', 'oauth_client_access_tests found' do
        let(:uid) { auth_headers[:uid] }
        let(:'access-token') { auth_headers[:token] }
        let(:client) { auth_headers[:client] }
        let(:'api-version') { API_VERSION }
        schema type: :array,
               items: {
                 type: :object,
                 properties: oauth_client_access_test_properties
               }
        run_test!
      end

      response '406', 'unsupported accept header' do
        let(:uid) { auth_headers[:uid] }
        let(:'access-token') { auth_headers[:token] }
        let(:client) { auth_headers[:client] }
        let(:'api-version') { API_VERSION }
        let(:Accept) { 'application/html' }
        run_test!
      end

      response '410', 'invalid api version' do
        let(:uid) { auth_headers[:uid] }
        let(:'access-token') { auth_headers[:token] }
        let(:client) { auth_headers[:client] }
        let(:'api-version') { 'invalid' }
        run_test!
      end

      response '410', 'no api version' do
        let(:uid) { auth_headers[:uid] }
        let(:'access-token') { auth_headers[:token] }
        let(:client) { auth_headers[:client] }
        let(:'api-version') { nil }
        run_test!
      end

      response '401', 'invalid auth token' do
        let(:uid) { auth_headers[:uid] }
        let(:'access-token') { 'invalid' }
        let(:client) { auth_headers[:client] }
        let(:'api-version') { API_VERSION }
        run_test!
      end

      response '401', 'no auth token' do
        let(:uid) { auth_headers[:uid] }
        let(:'access-token') { nil }
        let(:client) { auth_headers[:client] }
        let(:'api-version') { API_VERSION }
        run_test!
      end
    end
  end

  # POST search action
  path '/api/oauth_client_access_tests/search' do
    post 'Searches for oauth_client_access_tests' do
      tags 'OauthClientAccessTests'
      parameter name: :uid, in: :header, type: :string
      parameter name: :client, in: :header, type: :string
      parameter name: :'access-token', in: :header, type: :string
      produces 'application/json'
      consumes 'application/json'
      parameter name: :'api-version', in: :header, type: :string, default: API_VERSION
      parameter name: :oauth_client_access_test,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    oauth_client_access_test: {
                      type: :object,
                      properties: oauth_client_access_test_properties.merge(
                        id: { type: :integer },
                        owner_id: { type: :integer }
                      )
                    }
                  }
                }

      response '200', 'oauth_client_access_tests found' do
        let(:uid) { auth_headers[:uid] }
        let(:'access-token') { auth_headers[:token] }
        let(:client) { auth_headers[:client] }
        let(:'api-version') { API_VERSION }
        schema type: :array,
               items: {
                 type: :object,
                 properties: oauth_client_access_test_properties
               }
        let(:oauth_client_access_test) { oauth_client_access_test_param }
        run_test!
      end

      response '406', 'unsupported accept header' do
        let(:uid) { auth_headers[:uid] }
        let(:'access-token') { auth_headers[:token] }
        let(:client) { auth_headers[:client] }
        let(:'api-version') { API_VERSION }
        let(:Accept) { 'application/html' }
        let(:oauth_client_access_test) { oauth_client_access_test_param }
        run_test!
      end

      response '410', 'invalid api version' do
        let(:uid) { auth_headers[:uid] }
        let(:'access-token') { auth_headers[:token] }
        let(:client) { auth_headers[:client] }
        let(:'api-version') { 'invalid' }
        let(:oauth_client_access_test) { oauth_client_access_test_param }
        run_test!
      end

      response '410', 'no api version' do
        let(:uid) { auth_headers[:uid] }
        let(:'access-token') { auth_headers[:token] }
        let(:client) { auth_headers[:client] }
        let(:'api-version') { nil }
        let(:oauth_client_access_test) { oauth_client_access_test_param }
        run_test!
      end

      response '401', 'invalid auth token' do
        let(:uid) { auth_headers[:uid] }
        let(:'access-token') { 'invalid' }
        let(:client) { auth_headers[:client] }
        let(:'api-version') { API_VERSION }
        let(:oauth_client_access_test) { oauth_client_access_test_param }
        run_test!
      end

      response '401', 'no auth token' do
        let(:uid) { auth_headers[:uid] }
        let(:'access-token') { nil }
        let(:client) { auth_headers[:client] }
        let(:'api-version') { API_VERSION }
        let(:oauth_client_access_test) { oauth_client_access_test_param }
        run_test!
      end
    end
  end

  # GET show action
  path '/api/oauth_client_access_tests/{id}' do
    get 'Retrieves a oauth_client_access_test' do
      tags 'OauthClientAccessTests'
      parameter name: :uid, in: :header, type: :string
      parameter name: :client, in: :header, type: :string
      parameter name: :'access-token', in: :header, type: :string
      produces 'application/json'
      parameter name: :'api-version', in: :header, type: :string, default: API_VERSION
      parameter name: :id, in: :path, type: :integer

      response '200', 'oauth_client_access_test found' do
        schema type: :object,
               properties: oauth_client_access_test_properties
        let(:uid) { auth_headers[:uid] }
        let(:'access-token') { auth_headers[:token] }
        let(:client) { auth_headers[:client] }
        let(:'api-version') { API_VERSION }
        let(:id) { oauth_client_access_test_obj.id }
        run_test!
      end

      response '404', 'oauth_client_access_test not found' do
        let(:uid) { auth_headers[:uid] }
        let(:'access-token') { auth_headers[:token] }
        let(:client) { auth_headers[:client] }
        let(:'api-version') { API_VERSION }
        let(:id) { 'invalid' }
        run_test!
      end

      response '406', 'unsupported accept header' do
        let(:uid) { auth_headers[:uid] }
        let(:'access-token') { auth_headers[:token] }
        let(:client) { auth_headers[:client] }
        let(:'api-version') { API_VERSION }
        let(:id) { oauth_client_access_test_obj.id }
        let(:Accept) { 'application/html' }
        run_test!
      end

      response '410', 'invalid api version' do
        let(:uid) { auth_headers[:uid] }
        let(:'access-token') { auth_headers[:token] }
        let(:client) { auth_headers[:client] }
        let(:'api-version') { 'invalid' }
        let(:id) { oauth_client_access_test_obj.id }
        run_test!
      end

      response '410', 'no api version' do
        let(:uid) { auth_headers[:uid] }
        let(:'access-token') { auth_headers[:token] }
        let(:client) { auth_headers[:client] }
        let(:'api-version') { nil }
        let(:id) { oauth_client_access_test_obj.id }
        run_test!
      end

      response '401', 'invalid auth token' do
        let(:uid) { auth_headers[:uid] }
        let(:'access-token') { 'invalid' }
        let(:client) { auth_headers[:client] }
        let(:'api-version') { API_VERSION }
        let(:id) { oauth_client_access_test_obj.id }
        run_test!
      end

      response '401', 'no auth token' do
        let(:uid) { auth_headers[:uid] }
        let(:'access-token') { nil }
        let(:client) { auth_headers[:client] }
        let(:'api-version') { API_VERSION }
        let(:id) { oauth_client_access_test_obj.id }
        run_test!
      end
    end
  end

  # POST create action
  path '/api/oauth_client_access_tests' do
    post 'Creates a oauth_client_access_test' do
      tags 'OauthClientAccessTests'
      parameter name: :uid, in: :header, type: :string
      parameter name: :client, in: :header, type: :string
      parameter name: :'access-token', in: :header, type: :string
      consumes 'application/json'
      produces 'application/json'
      parameter name: :'api-version', in: :header, type: :string, default: API_VERSION
      parameter name: :oauth_client_access_test,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    oauth_client_access_test: {
                      type: :object,
                      properties: oauth_client_access_test_properties
                    }
                  }
                }

      response '201', 'oauth_client_access_test created' do
        let(:uid) { auth_headers[:uid] }
        let(:'access-token') { auth_headers[:token] }
        let(:client) { auth_headers[:client] }
        let(:'api-version') { API_VERSION }
        let(:oauth_client_access_test) { oauth_client_access_test_param }
        run_test!
      end

      response '406', 'unsupported accept header' do
        let(:uid) { auth_headers[:uid] }
        let(:'access-token') { auth_headers[:token] }
        let(:client) { auth_headers[:client] }
        let(:'api-version') { API_VERSION }
        let(:Accept) { 'application/html' }
        let(:oauth_client_access_test) { oauth_client_access_test_param }
        run_test!
      end

      response '410', 'invalid api version' do
        let(:uid) { auth_headers[:uid] }
        let(:'access-token') { auth_headers[:token] }
        let(:client) { auth_headers[:client] }
        let(:'api-version') { 'invalid' }
        let(:oauth_client_access_test) { oauth_client_access_test_param }
        run_test!
      end

      response '410', 'no api version' do
        let(:uid) { auth_headers[:uid] }
        let(:'access-token') { auth_headers[:token] }
        let(:client) { auth_headers[:client] }
        let(:'api-version') { nil }
        let(:oauth_client_access_test) { oauth_client_access_test_param }
        run_test!
      end

      response '401', 'invalid auth token' do
        let(:uid) { auth_headers[:uid] }
        let(:'access-token') { 'invalid' }
        let(:client) { auth_headers[:client] }
        let(:'api-version') { API_VERSION }
        let(:oauth_client_access_test) { oauth_client_access_test_param }
        run_test!
      end

      response '401', 'no auth token' do
        let(:uid) { auth_headers[:uid] }
        let(:'access-token') { nil }
        let(:client) { auth_headers[:client] }
        let(:'api-version') { API_VERSION }
        let(:oauth_client_access_test) { oauth_client_access_test_param }
        run_test!
      end
    end
  end

  # PATCH update action
  path '/api/oauth_client_access_tests/{id}' do
    patch 'Updates a oauth_client_access_test' do
      tags 'OauthClientAccessTests'
      parameter name: :uid, in: :header, type: :string
      parameter name: :client, in: :header, type: :string
      parameter name: :'access-token', in: :header, type: :string
      consumes 'application/json'
      produces 'application/json'
      parameter name: :'api-version', in: :header, type: :string, default: API_VERSION
      parameter name: :id, in: :path, type: :integer
      parameter name: :oauth_client_access_test,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    oauth_client_access_test: {
                      type: :object,
                      properties: oauth_client_access_test_properties
                    }
                  }
                }

      response '200', 'oauth_client_access_test updated' do
        let(:uid) { auth_headers[:uid] }
        let(:'access-token') { auth_headers[:token] }
        let(:client) { auth_headers[:client] }
        let(:'api-version') { API_VERSION }
        let(:id) { oauth_client_access_test_obj.id }
        let(:oauth_client_access_test) { oauth_client_access_test_param }
        run_test!
      end

      response '406', 'unsupported accept header' do
        let(:uid) { auth_headers[:uid] }
        let(:'access-token') { auth_headers[:token] }
        let(:client) { auth_headers[:client] }
        let(:'api-version') { API_VERSION }
        let(:id) { oauth_client_access_test_obj.id }
        let(:oauth_client_access_test) { oauth_client_access_test_param }
        let(:Accept) { 'application/html' }
        run_test!
      end

      response '410', 'invalid api version' do
        let(:uid) { auth_headers[:uid] }
        let(:'access-token') { auth_headers[:token] }
        let(:client) { auth_headers[:client] }
        let(:'api-version') { 'invalid' }
        let(:id) { oauth_client_access_test_obj.id }
        let(:oauth_client_access_test) { oauth_client_access_test_param }
        run_test!
      end

      response '410', 'no api version' do
        let(:uid) { auth_headers[:uid] }
        let(:'access-token') { auth_headers[:token] }
        let(:client) { auth_headers[:client] }
        let(:'api-version') { nil }
        let(:id) { oauth_client_access_test_obj.id }
        let(:oauth_client_access_test) { oauth_client_access_test_param }
        run_test!
      end

      response '401', 'invalid auth token' do
        let(:uid) { auth_headers[:uid] }
        let(:'access-token') { 'invalid' }
        let(:client) { auth_headers[:client] }
        let(:'api-version') { API_VERSION }
        let(:id) { oauth_client_access_test_obj.id }
        let(:oauth_client_access_test) { oauth_client_access_test_param }
        run_test!
      end

      response '401', 'no auth token' do
        let(:uid) { auth_headers[:uid] }
        let(:'access-token') { nil }
        let(:client) { auth_headers[:client] }
        let(:'api-version') { API_VERSION }
        let(:id) { oauth_client_access_test_obj.id }
        let(:oauth_client_access_test) { oauth_client_access_test_param }
        run_test!
      end
    end
  end

  # DELETE destroy action
  path '/api/oauth_client_access_tests/{id}' do
    delete 'Destroys a OauthClientAccessTest' do
      tags 'OauthClientAccessTests'
      parameter name: :uid, in: :header, type: :string
      parameter name: :client, in: :header, type: :string
      parameter name: :'access-token', in: :header, type: :string
      consumes 'application/json'
      produces 'application/json'
      parameter name: :'api-version', in: :header, type: :string, default: API_VERSION
      parameter name: :id, in: :path, type: :integer

      response '204', 'oauth_client_access_test destroyed' do
        let(:uid) { auth_headers[:uid] }
        let(:'access-token') { auth_headers[:token] }
        let(:client) { auth_headers[:client] }
        let(:'api-version') { API_VERSION }
        let(:id) { oauth_client_access_test_obj.id }
        run_test!
      end

      response '406', 'unsupported accept header' do
        let(:uid) { auth_headers[:uid] }
        let(:'access-token') { auth_headers[:token] }
        let(:client) { auth_headers[:client] }
        let(:'api-version') { API_VERSION }
        let(:Accept) { 'application/html' }
        let(:id) { oauth_client_access_test_obj.id }
        run_test!
      end

      response '410', 'invalid api version' do
        let(:uid) { auth_headers[:uid] }
        let(:'access-token') { auth_headers[:token] }
        let(:client) { auth_headers[:client] }
        let(:'api-version') { 'invalid' }
        let(:id) { oauth_client_access_test_obj.id }
        run_test!
      end

      response '410', 'no api version' do
        let(:uid) { auth_headers[:uid] }
        let(:'access-token') { auth_headers[:token] }
        let(:client) { auth_headers[:client] }
        let(:'api-version') { nil }
        let(:id) { oauth_client_access_test_obj.id }
        run_test!
      end

      response '401', 'invalid auth token' do
        let(:uid) { auth_headers[:uid] }
        let(:'access-token') { 'invalid' }
        let(:client) { auth_headers[:client] }
        let(:'api-version') { API_VERSION }
        let(:id) { oauth_client_access_test_obj.id }
        run_test!
      end

      response '401', 'no auth token' do
        let(:uid) { auth_headers[:uid] }
        let(:'access-token') { nil }
        let(:client) { auth_headers[:client] }
        let(:'api-version') { API_VERSION }
        let(:id) { oauth_client_access_test_obj.id }
        run_test!
      end
    end
  end
end
