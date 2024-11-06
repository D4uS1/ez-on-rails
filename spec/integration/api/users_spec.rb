# frozen_string_literal: true

require 'swagger_helper'

describe 'Users API' do
  let(:andrew) { create(:andrew) }
  let(:auth_header_info) { authorization_header_info(andrew) }

  # GET me action
  path '/api/users/me' do
    get 'Retrieves own user profile' do
      tags 'Users'
      security [{ access_token: [], client: [], uid: [] }]
      produces 'application/json'
      parameter name: :'api-version', in: :header, type: :string, default: API_VERSION

      response '200', 'own user profile found' do
        schema '$ref' => '#/components/schemas/UserProfile'

        let(:uid) { auth_header_info[:uid] }
        let(:'access-token') { auth_header_info[:token] }
        let(:client) { auth_header_info[:client] }
        let(:'api-version') { API_VERSION }

        run_test!
      end

      response '406', 'unsupported accept header' do
        let(:uid) { auth_header_info[:uid] }
        let(:'access-token') { auth_header_info[:token] }
        let(:client) { auth_header_info[:client] }
        let(:'api-version') { API_VERSION }
        let(:Accept) { 'application/html' }

        run_test!
      end

      response '410', 'invalid api version' do
        let(:uid) { auth_header_info[:uid] }
        let(:'access-token') { auth_header_info[:token] }
        let(:client) { auth_header_info[:client] }
        let(:'api-version') { 'invalid' }

        run_test!
      end

      response '410', 'no api version' do
        let(:uid) { auth_header_info[:uid] }
        let(:'access-token') { auth_header_info[:token] }
        let(:client) { auth_header_info[:client] }
        let(:'api-version') { nil }

        run_test!
      end

      response '401', 'invalid auth token' do
        let(:uid) { auth_header_info[:uid] }
        let(:'access-token') { 'invalid' }
        let(:client) { auth_header_info[:client] }
        let(:'api-version') { API_VERSION }

        run_test!
      end

      response '401', 'no auth token' do
        let(:uid) { auth_header_info[:uid] }
        let(:'access-token') { nil }
        let(:client) { auth_header_info[:client] }
        let(:'api-version') { API_VERSION }

        run_test!
      end
    end
  end

  # PUT update_me action
  path '/api/users/me' do
    patch 'Updates own user profile' do
      tags 'Users'
      security [{ access_token: [], client: [], uid: [] }]
      produces 'application/json'
      consumes 'application/json'
      parameter name: :'api-version', in: :header, type: :string, default: API_VERSION
      parameter name: :user,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    user: {
                      type: :object,
                      properties: {
                        email: { type: :string, nullable: true },
                        username: { type: :string, nullable: true },
                        avatar: { type: :string, nullable: true },
                        password: { type: :string, nullable: true },
                        password_confirmation: { type: :string, nullable: true }
                      }
                    }
                  }
                }

      response '200', 'own user profile updated' do
        schema '$ref' => '#/components/schemas/UserProfile'

        let(:uid) { auth_header_info[:uid] }
        let(:'access-token') { auth_header_info[:token] }
        let(:client) { auth_header_info[:client] }
        let(:'api-version') { API_VERSION }
        let(:user) do
          {
            user: {
              username: 'NewUsername'
            }
          }
        end

        run_test!
      end

      response '406', 'unsupported accept header' do
        let(:uid) { auth_header_info[:uid] }
        let(:'access-token') { auth_header_info[:token] }
        let(:client) { auth_header_info[:client] }
        let(:'api-version') { API_VERSION }
        let(:Accept) { 'application/html' }
        let(:user) do
          {
            user: {
              username: 'NewUsername'
            }
          }
        end

        run_test!
      end

      response '410', 'invalid api version' do
        let(:uid) { auth_header_info[:uid] }
        let(:'access-token') { auth_header_info[:token] }
        let(:client) { auth_header_info[:client] }
        let(:'api-version') { 'invalid' }
        let(:user) do
          {
            user: {
              username: 'NewUsername'
            }
          }
        end

        run_test!
      end

      response '410', 'no api version' do
        let(:uid) { auth_header_info[:uid] }
        let(:'access-token') { auth_header_info[:token] }
        let(:client) { auth_header_info[:client] }
        let(:'api-version') { nil }
        let(:user) do
          {
            user: {
              username: 'NewUsername'
            }
          }
        end

        run_test!
      end

      response '401', 'invalid auth token' do
        let(:uid) { auth_header_info[:uid] }
        let(:'access-token') { 'invalid' }
        let(:client) { auth_header_info[:client] }
        let(:'api-version') { API_VERSION }
        let(:user) do
          {
            user: {
              username: 'NewUsername'
            }
          }
        end

        run_test!
      end

      response '401', 'no auth token' do
        let(:uid) { auth_header_info[:uid] }
        let(:'access-token') { nil }
        let(:client) { auth_header_info[:client] }
        let(:'api-version') { API_VERSION }
        let(:user) do
          {
            user: {
              username: 'NewUsername'
            }
          }
        end

        run_test!
      end
    end
  end
end
