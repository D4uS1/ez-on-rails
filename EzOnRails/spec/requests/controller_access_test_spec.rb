# frozen_string_literal: true

require 'rails_helper'

# Spec for testing the access for protected controllers.
RSpec.describe 'controller_access_test', type: :request do
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
