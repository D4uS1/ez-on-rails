# frozen_string_literal: true

require 'rails_helper'

# Spec for testing the access for the actions in Admin::UserManagement::DashboardController.
# Testing whether a non looged in user (called anonymus here) can not get any action, because the access can be denied.
# Testing whether some non admin logged in user (called andrew here) can not get any action,
# because the access can be denied.
# Testing whether admin can get the actions, because the access is granted.
RSpec.describe 'ez_on_rails/admin/user_management/dashboard', type: :request do
  # users
  let(:andrew) { create(:andrew) }
  let(:admin) { User.super_admin }

  context 'when not logged in' do
    it 'can not get index' do
      get '/ez_on_rails/admin/user_management/dashboard'

      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'when logged in as andrew' do
    before do
      sign_in andrew
    end

    it 'can not get index' do
      get '/ez_on_rails/admin/user_management/dashboard'

      expect(response).to have_http_status(:forbidden)
    end
  end

  context 'when logged in as admin' do
    before do
      sign_in admin
    end

    it 'can get index' do
      get '/ez_on_rails/admin/user_management/dashboard'

      expect(response).to have_http_status(:success)
    end
  end
end
