# frozen_string_literal: true

require 'rails_helper'

# Spec for testing the access for the actions in Admin::UserManagement::UsersController.
# Testing whether a non looged in user (called anonymus here) can not get any action, because the
# access should be denied.
# Testing whether some non admin logged in user (called andrew here) can not get any action, because the
# access should be denied.
# Testing whether admin can get the actions, because the access is granted.
# This spec also tests the basic CRUD functionality of the actions which should Create, Update or Destroy
# ActiveRecord instance.
RSpec.describe 'users', type: :request do
  # users
  let(:andrew) { create(:andrew) }
  let(:admin) { User.super_admin }

  # for create actions
  let(:member_group) { EzOnRails::Group.member_group }
  let(:user_create) do
    build(:user,
          username: 'UserToCreate',
          email: 'create@me.com',
          password: 'createcreate')
  end

  context 'when not logged in' do
    it 'can not show user' do
      get user_url(andrew)

      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'when logged in as andrew' do
    before do
      sign_in andrew
    end

    it 'can not show user' do
      get user_url(andrew)

      expect(response).to have_http_status(:forbidden)
    end
  end

  context 'when logged in as admin' do
    before do
      sign_in admin
    end

    it 'can show user' do
      get user_url(andrew)

      expect(response).to have_http_status(:success)
    end
  end
end
