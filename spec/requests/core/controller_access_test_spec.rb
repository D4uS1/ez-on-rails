# frozen_string_literal: true

require 'rails_helper'

# Spec for testing the access for protected controllers.
RSpec.describe 'ControllerAccessTestController' do
  context 'when using groups' do
    let(:testgroup) { create(:testgroup) }
    let(:andrew) { create(:andrew) }
    let(:john) { create(:john) }
    let(:admin) { User.super_admin }

    before do
      create(:eor_group_access,
             group: testgroup,
             namespace: nil,
             controller: 'controller_access_test')
      create(:eor_user_group_assignment,
             user: andrew,
             group: testgroup)
    end

    # users

    context 'when not logged in' do
      it 'can not access controller action' do
        get '/controller_access_test/some_action'

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when logged in as user in access group' do
      before do
        sign_in andrew
      end

      it 'can access controller action' do
        get '/controller_access_test/some_action'

        expect(response).to have_http_status(:success)
      end
    end

    context 'when logged in as user not access group' do
      before do
        sign_in john
      end

      it 'can not access controller action' do
        get '/controller_access_test/some_action'

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when logged in as admin' do
      before do
        sign_in admin
      end

      it 'can access controller action' do
        get '/controller_access_test/some_action'

        expect(response).to have_http_status(:success)
      end
    end
  end

  context 'when using api keys' do
    let(:api_key) { create(:eor_api_key) }
    let(:auth_headers) do
      auth_header_data = api_key_header_info(api_key)

      {
        'api-key': auth_header_data[:api_key]
      }
    end

    before do
      create(:eor_group_access,
             group: EzOnRails::Group.api_key_group,
             namespace: nil,
             controller: 'controller_access_test')
    end

    context 'when using no api key' do
      it 'can not access controller action' do
        get '/controller_access_test/some_action'

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when using an invalid api key' do
      it 'can not access controller action' do
        get '/controller_access_test/some_action', headers: auth_headers.merge({ 'api-key': 'invalid' })

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when using an expired api key' do
      before do
        api_key.update(expires_at: 1.day.ago)
      end

      it 'can not access controller action' do
        get '/controller_access_test/some_action', headers: auth_headers

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when using a valid api key' do
      it 'can not access controller action' do
        get '/controller_access_test/some_action', headers: auth_headers

        expect(response).to have_http_status(:success)
      end
    end
  end
end
