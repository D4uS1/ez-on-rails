# frozen_string_literal: true

require 'rails_helper'

# Spec for testing the access for protected namespaces that contains
# actions that has also protection rules.
RSpec.describe 'namespaced/mixed_action_access_test', type: :request do
  let(:andrew) { create(:andrew) }
  let(:john) { create(:john) }
  let(:admin) { User.super_admin }
  let(:bob) { create(:bob) }
  let(:namespace_group) do
    create(:eor_group, name: 'NamespaceGroup')
  end
  let(:action_group) do
    create(:eor_group, name: 'ActionGroup')
  end

  before do
    create(:eor_group_access,
           group: namespace_group,
           namespace: 'namespaced')
    create(:eor_group_access,
           group: action_group,
           namespace: 'namespaced',
           controller: 'mixed_action_access_test',
           action: 'action_protected')
    create(:eor_user_group_assignment,
           user: andrew,
           group: namespace_group)
    create(:eor_user_group_assignment,
           user: john,
           group: action_group)
  end

  # users

  context 'when not logged in' do
    it 'can not access namespace protected action' do
      get '/namespaced/mixed_action_access_test/namespace_protected'

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not access action protected action' do
      get '/namespaced/mixed_action_access_test/action_protected'

      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'when logged in as user in namespace access group' do
    before do
      sign_in andrew
    end

    it 'can access namespace protected action' do
      get '/namespaced/mixed_action_access_test/namespace_protected'

      expect(response).to have_http_status(:success)
    end

    it 'can not access action protected action' do
      get '/namespaced/mixed_action_access_test/action_protected'

      expect(response).to have_http_status(:forbidden)
    end
  end

  context 'when logged in as user in action access group' do
    before do
      sign_in john
    end

    it 'can not access namespace protected action' do
      get '/namespaced/mixed_action_access_test/namespace_protected'

      expect(response).to have_http_status(:forbidden)
    end

    it 'can access action protected action' do
      get '/namespaced/mixed_action_access_test/action_protected'

      expect(response).to have_http_status(:success)
    end
  end

  context 'when logged in as user in no access group' do
    before do
      sign_in bob
    end

    it 'can not access namespace protected action' do
      get '/namespaced/mixed_action_access_test/namespace_protected'

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not access action protected action' do
      get '/namespaced/mixed_action_access_test/action_protected'

      expect(response).to have_http_status(:forbidden)
    end
  end

  context 'when logged in as admin' do
    before do
      sign_in admin
    end

    it 'can not access namespace protected action' do
      get '/namespaced/mixed_action_access_test/namespace_protected'

      expect(response).to have_http_status(:success)
    end

    it 'can not access action protected action' do
      get '/namespaced/mixed_action_access_test/action_protected'

      expect(response).to have_http_status(:success)
    end
  end
end
