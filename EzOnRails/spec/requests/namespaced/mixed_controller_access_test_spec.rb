# frozen_string_literal: true

require 'rails_helper'

# Spec for testing the access for protected namespaces that contains
# controllers that has also protection rules.
RSpec.describe 'namespaced/mixed_controller_access_test', type: :request do
  let(:andrew) { create(:andrew) }
  let(:john) { create(:john) }
  let(:admin) { User.super_admin }
  let(:bob) { create(:bob) }
  let(:namespace_group) do
    create(:eor_group, name: 'NamespaceGroup')
  end
  let(:controller_group) do
    create(:eor_group, name: 'ControllerOneGroup')
  end

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
