# frozen_string_literal: true

require 'rails_helper'

# Spec for testing the access for protected namespaces that contains
# controllers that has also protection rules.
RSpec.describe 'Namespaced::MixedControllerTwoAccessTestController' do
  let(:namespace_group) do
    create(:eor_group, name: 'NamespaceGroup')
  end
  let(:controller_group) do
    create(:eor_group, name: 'ControllerOneGroup')
  end

  context 'when using groups' do
    let(:andrew) { create(:andrew) }
    let(:john) { create(:john) }
    let(:admin) { User.super_admin }
    let(:bob) { create(:bob) }

    before do
      create(:eor_group_access,
             group: namespace_group,
             namespace: 'namespaced')
      create(:eor_group_access,
             group: controller_group,
             namespace: 'namespaced',
             controller: 'mixed_controller_one_access_test')
      create(:eor_user_group_assignment,
             user: andrew,
             group: namespace_group)
      create(:eor_user_group_assignment,
             user: john,
             group: controller_group)
    end

    context 'when not logged in' do
      it 'can not access namespace protected action' do
        get '/namespaced/mixed_controller_two_access_test/some_action'

        expect(response).to redirect_to(new_user_session_path)
      end

      it 'can not access controller protected action' do
        get '/namespaced/mixed_controller_one_access_test/some_action'

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when logged in as user in namespace access group' do
      before do
        sign_in andrew
      end

      it 'can access namespace protected action' do
        get '/namespaced/mixed_controller_two_access_test/some_action'

        expect(response).to have_http_status(:success)
      end

      it 'can not access controller protected action' do
        get '/namespaced/mixed_controller_one_access_test/some_action'

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when logged in as user in controller access group' do
      before do
        sign_in john
      end

      it 'can not access namespace protected action' do
        get '/namespaced/mixed_controller_two_access_test/some_action'

        expect(response).to have_http_status(:forbidden)
      end

      it 'can access controller protected action' do
        get '/namespaced/mixed_controller_one_access_test/some_action'

        expect(response).to have_http_status(:success)
      end
    end

    context 'when logged in as user in no access group' do
      before do
        sign_in bob
      end

      it 'can not access namespace protected action' do
        get '/namespaced/mixed_controller_two_access_test/some_action'

        expect(response).to have_http_status(:forbidden)
      end

      it 'can not access controller protected action' do
        get '/namespaced/mixed_controller_one_access_test/some_action'

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when logged in as admin' do
      before do
        sign_in admin
      end

      it 'can access namespace protected action' do
        get '/namespaced/mixed_controller_two_access_test/some_action'

        expect(response).to have_http_status(:success)
      end

      it 'can access controller protected action' do
        get '/namespaced/mixed_controller_one_access_test/some_action'

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

    context 'when using no api key' do
      context 'when having api key protected namespace' do
        before do
          create(:eor_group_access,
                 group: EzOnRails::Group.api_key_group,
                 namespace: 'namespaced')
          create(:eor_group_access,
                 group: controller_group,
                 namespace: 'namespaced',
                 controller: 'mixed_controller_one_access_test')
        end

        it 'can not access action in namespace' do
          get '/namespaced/mixed_controller_two_access_test/some_action'

          expect(response).to redirect_to(new_user_session_path)
        end

        it 'can not access action in controller' do
          get '/namespaced/mixed_controller_one_access_test/some_action'

          expect(response).to redirect_to(new_user_session_path)
        end
      end

      context 'when having api key protected controller in namespace' do
        before do
          create(:eor_group_access,
                 group: namespace_group,
                 namespace: 'namespaced')
          create(:eor_group_access,
                 group: EzOnRails::Group.api_key_group,
                 namespace: 'namespaced',
                 controller: 'mixed_controller_one_access_test')
        end

        it 'can not access action in namespace' do
          get '/namespaced/mixed_controller_two_access_test/some_action'

          expect(response).to redirect_to(new_user_session_path)
        end

        it 'can not access action in controller' do
          get '/namespaced/mixed_controller_one_access_test/some_action'

          expect(response).to redirect_to(new_user_session_path)
        end
      end
    end

    context 'when using invalid api key' do
      context 'when having api key protected namespace' do
        before do
          create(:eor_group_access,
                 group: EzOnRails::Group.api_key_group,
                 namespace: 'namespaced')
          create(:eor_group_access,
                 group: controller_group,
                 namespace: 'namespaced',
                 controller: 'mixed_controller_one_access_test')
        end

        it 'can not access action in namespace' do
          get '/namespaced/mixed_controller_two_access_test/some_action',
              headers: auth_headers.merge({ 'api-key': 'invalid' })

          expect(response).to redirect_to(new_user_session_path)
        end

        it 'can not access action in controller' do
          get '/namespaced/mixed_controller_one_access_test/some_action',
              headers: auth_headers.merge({ 'api-key': 'invalid' })

          expect(response).to redirect_to(new_user_session_path)
        end
      end

      context 'when having api key protected controller in namespace' do
        before do
          create(:eor_group_access,
                 group: namespace_group,
                 namespace: 'namespaced')
          create(:eor_group_access,
                 group: EzOnRails::Group.api_key_group,
                 namespace: 'namespaced',
                 controller: 'mixed_controller_one_access_test')
        end

        it 'can not access action in namespace' do
          get '/namespaced/mixed_controller_two_access_test/some_action',
              headers: auth_headers.merge({ 'api-key': 'invalid' })

          expect(response).to redirect_to(new_user_session_path)
        end

        it 'can not access action in controller' do
          get '/namespaced/mixed_controller_one_access_test/some_action',
              headers: auth_headers.merge({ 'api-key': 'invalid' })

          expect(response).to redirect_to(new_user_session_path)
        end
      end
    end

    context 'when using valid api key' do
      context 'when having api key protected namespace' do
        before do
          create(:eor_group_access,
                 group: EzOnRails::Group.api_key_group,
                 namespace: 'namespaced')
          create(:eor_group_access,
                 group: controller_group,
                 namespace: 'namespaced',
                 controller: 'mixed_controller_one_access_test')
        end

        it 'can access action in namespace' do
          get '/namespaced/mixed_controller_two_access_test/some_action', headers: auth_headers

          expect(response).to have_http_status(:success)
        end

        it 'can not access action in controller' do
          get '/namespaced/mixed_controller_one_access_test/some_action', headers: auth_headers

          expect(response).to redirect_to(new_user_session_path)
        end
      end

      context 'when having api key protected controller in namespace' do
        before do
          create(:eor_group_access,
                 group: namespace_group,
                 namespace: 'namespaced')
          create(:eor_group_access,
                 group: EzOnRails::Group.api_key_group,
                 namespace: 'namespaced',
                 controller: 'mixed_controller_one_access_test')
        end

        it 'can not access action in namespace' do
          get '/namespaced/mixed_controller_two_access_test/some_action', headers: auth_headers

          expect(response).to redirect_to(new_user_session_path)
        end

        it 'can access action in controller' do
          get '/namespaced/mixed_controller_one_access_test/some_action', headers: auth_headers

          expect(response).to have_http_status(:success)
        end
      end
    end
  end
end
