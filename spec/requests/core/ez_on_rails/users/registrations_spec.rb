# frozen_string_literal: true

require 'rails_helper'

# Spec for testing the overwritten devise methods in the registrations controller.
RSpec.describe 'Users::RegistrationsController' do
  # users
  let(:andrew) { create(:andrew) }
  let(:admin) { User.super_admin }

  context 'when not logged in' do
    it 'can not update' do
      put user_registration_path, params: {
        id: andrew.id
      }

      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'when logged in as andrew' do
    before do
      sign_in andrew
    end

    it 'can update his account with correct password' do
      old_password = andrew.encrypted_password

      put user_registration_path, params: {
        user: {
          password: 'newpassword',
          password_confirmation: 'newpassword',
          current_password: andrew.password
        }
      }

      andrew.reload
      expect(response).to redirect_to(root_path)
      expect(andrew.encrypted_password).not_to eq(old_password)
    end

    it 'can not update his account with incorrect password' do
      old_password = andrew.encrypted_password

      put user_registration_path, params: {
        user: {
          password: 'newpassword',
          password_confirmation: 'newpassword',
          current_password: 'wrong_password'
        }
      }

      andrew.reload
      expect(response).to have_http_status(:success) # this is not unprocessable_content because of devise default
      expect(andrew.encrypted_password).to eq(old_password)
    end

    it 'can destroy his account with correct password' do
      users_count = User.count

      put user_registration_path, params: {
        commit: I18n.t(:remove_account),
        user: {
          current_password: andrew.password
        }
      }

      expect(response).to redirect_to(root_path)
      expect(User.count).to eq(users_count - 1)
      expect(User.find_by(id: andrew.id)).to be_nil
    end

    it 'can not destroy his account with incorrect password' do
      users_count = User.count

      put user_registration_path, params: {
        commit: I18n.t(:remove_account),
        user: {
          current_password: 'incorrect_password'
        }
      }

      expect(response).to have_http_status(:success)  # this is not unprocessable_content because of devise default
      expect(User.count).to eq(users_count)
    end
  end

  context 'when logged in as admin' do
    before do
      sign_in andrew
    end

    it 'can not delete his account' do
      users_count = User.count

      put user_registration_path, params: {
        commit: I18n.t(:remove_account),
        user: {
          current_password: admin.password
        }
      }

      expect(response).to have_http_status(:success)  # this is not unprocessable_content because of devise default
      expect(User.count).to eq(users_count)
    end
  end
end
