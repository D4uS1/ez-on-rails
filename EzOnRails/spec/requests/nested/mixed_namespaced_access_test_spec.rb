# frozen_string_literal: true

require 'rails_helper'

# Spec for testing the access for protected namespaces that contains
# nested namespaces that has also protection rules.
RSpec.describe 'Nested::MixedNamespaceAccessTestController' do
  let(:andrew) { create(:andrew) }
  let(:john) { create(:john) }
  let(:admin) { User.super_admin }
  let(:bob) { create(:bob) }
  let(:namespace_group) do
    create(:eor_group, name: 'NamespaceGroup')
  end
  let(:nested_namespace_group) do
    create(:eor_group, name: 'NestedNamespaceGroup')
  end

  before do
    create(:eor_group_access,
           group: namespace_group,
           namespace: 'nested')
    create(:eor_group_access,
           group: nested_namespace_group,
           namespace: 'nested/namespaced')
    create(:eor_user_group_assignment,
           user: andrew,
           group: namespace_group)
    create(:eor_user_group_assignment,
           user: john,
           group: nested_namespace_group)
  end

  context 'when not logged in' do
    it 'can not access namespace protected action' do
      get '/nested/mixed_namespace_access_test/some_action'

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not access nested namespace protected action' do
      get '/nested/namespaced/access_test/some_action'

      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'when logged in as user in namespace access group' do
    before do
      sign_in andrew
    end

    it 'can access namespace protected action' do
      get '/nested/mixed_namespace_access_test/some_action'

      expect(response).to have_http_status(:success)
    end

    it 'can not access nested namespace protected action' do
      get '/nested/namespaced/access_test/some_action'

      expect(response).to have_http_status(:forbidden)
    end
  end

  context 'when logged in as user in nested namespace access group' do
    before do
      sign_in john
    end

    it 'can not access namespace protected action' do
      get '/nested/mixed_namespace_access_test/some_action'

      expect(response).to have_http_status(:forbidden)
    end

    it 'can access nested namespace protected action' do
      get '/nested/namespaced/access_test/some_action'

      expect(response).to have_http_status(:success)
    end
  end

  context 'when logged in as user in no access group' do
    before do
      sign_in bob
    end

    it 'can not access namespace protected action' do
      get '/nested/mixed_namespace_access_test/some_action'

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not access nested namespace protected action' do
      get '/nested/namespaced/access_test/some_action'

      expect(response).to have_http_status(:forbidden)
    end
  end

  context 'when logged in as admin' do
    before do
      sign_in admin
    end

    it 'can access namespace protected action' do
      get '/nested/mixed_namespace_access_test/some_action'

      expect(response).to have_http_status(:success)
    end

    it 'can access nested namespace protected action' do
      get '/nested/namespaced/access_test/some_action'

      expect(response).to have_http_status(:success)
    end
  end
end
