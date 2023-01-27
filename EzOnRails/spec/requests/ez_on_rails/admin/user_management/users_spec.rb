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
RSpec.describe 'EzOnRails::Admin::UserManagement::UsersController' do
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
    it 'can not get index' do
      get ez_on_rails_users_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not get search' do
      get search_ez_on_rails_users_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not search' do
      post search_ez_on_rails_users_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not get new' do
      get new_ez_on_rails_user_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not create user' do
      post ez_on_rails_users_url, params: {
        user: {
          username: user_create.username,
          email: user_create.email,
          password: user_create.password
        }
      }

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not show user' do
      get ez_on_rails_user_url(andrew)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not get edit' do
      get edit_ez_on_rails_user_url(andrew)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not get password_reset' do
      get password_reset_ez_on_rails_user_url(andrew)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not update user' do
      patch ez_on_rails_user_url(andrew), params: {
        user: {
          username: andrew.username,
          email: andrew.email,
          password: andrew.password
        }
      }

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not update password of user' do
      patch password_reset_ez_on_rails_user_url(andrew), params: {
        user: {
          password: 'andrewsnewpassword'
        }
      }

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not destroy user' do
      delete ez_on_rails_user_url(andrew)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not destroy selections' do
      delete destroy_selections_ez_on_rails_users_url

      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'when logged in as andrew' do
    before do
      sign_in andrew
    end

    it 'can not get index' do
      get ez_on_rails_users_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not get search' do
      get search_ez_on_rails_users_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not search' do
      post search_ez_on_rails_users_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not get new' do
      get new_ez_on_rails_user_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not create user' do
      post ez_on_rails_users_url, params: {
        user: {
          username: user_create.username,
          email: user_create.email,
          password: user_create.password
        }
      }

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not show user' do
      get ez_on_rails_user_url(andrew)

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not get edit' do
      get edit_ez_on_rails_user_url(andrew)

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not get password_reset' do
      get password_reset_ez_on_rails_user_url(andrew)

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not update user' do
      patch ez_on_rails_user_url(andrew), params: {
        user: {
          username: andrew.username,
          email: andrew.email,
          password: andrew.password
        }
      }

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not update password of user' do
      patch password_reset_ez_on_rails_user_url(andrew), params: {
        user: {
          password: 'andrewsnewpassword'
        }
      }

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not destroy user' do
      delete ez_on_rails_user_url(andrew)

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not destroy selections' do
      delete destroy_selections_ez_on_rails_users_url

      expect(response).to have_http_status(:forbidden)
    end
  end

  context 'when logged in as admin' do
    before do
      sign_in admin
    end

    it 'can get index' do
      get ez_on_rails_users_url

      expect(response).to have_http_status(:success)
    end

    it 'can get search' do
      get search_ez_on_rails_users_url

      expect(response).to have_http_status(:success)
    end

    it 'can search' do
      post search_ez_on_rails_users_url

      expect(response).to have_http_status(:success)
    end

    it 'can get new' do
      get new_ez_on_rails_user_url

      expect(response).to have_http_status(:success)
    end

    it 'can create user' do
      post ez_on_rails_users_url, params: {
        user: {
          username: user_create.username,
          email: user_create.email,
          password: user_create.password,
          privacy_policy_accepted: true
        }
      }

      created_object = User.last
      expect(created_object.username).to eql(user_create.username)
      expect(created_object.email).to eql(user_create.email)

      # Member group assignment exists for the created new user
      expect(EzOnRails::UserGroupAssignment.find_by(group: member_group, user: created_object)).not_to be_nil

      expect(response).to redirect_to(ez_on_rails_user_path(created_object))
    end

    it 'can show user' do
      get ez_on_rails_user_url(andrew)

      expect(response).to have_http_status(:success)
    end

    it 'can get edit' do
      get edit_ez_on_rails_user_url(andrew)

      expect(response).to have_http_status(:success)
    end

    it 'can get password_reset' do
      get password_reset_ez_on_rails_user_url(andrew)

      expect(response).to have_http_status(:success)
    end

    it 'can update user without need to confirm the email' do
      patch ez_on_rails_user_url(andrew), params: {
        user: {
          username: andrew.username,
          email: 'updated@email.de',
          password: 'andrewandrew'
        }
      }

      updated_object = User.find andrew.id
      expect(updated_object.email).to eql('updated@email.de')
      expect(updated_object.unconfirmed_email).to be_nil
      expect(updated_object.username).to eql(andrew.username)

      expect(response).to redirect_to(ez_on_rails_user_url(andrew))
    end

    it 'can update password of user' do
      old_password = andrew.encrypted_password

      patch password_reset_ez_on_rails_user_url(andrew), params: {
        user: {
          password: 'andrewsnewpassword'
        }
      }

      andrew.reload
      expect(response.status).to redirect_to(ez_on_rails_user_url(andrew))
      expect(andrew.encrypted_password).not_to eq(old_password)
    end

    it 'can destroy user' do
      delete ez_on_rails_user_url(andrew)

      expect(response).to redirect_to(ez_on_rails_users_path)
      expect(User.find_by(id: andrew.id)).to be_nil
    end

    it 'can not destroy admin' do
      delete ez_on_rails_user_url(admin)

      expect(User.find_by(id: admin.id)).not_to be_nil
    end

    it 'can not update admin username' do
      patch ez_on_rails_user_url(admin), params: {
        user: {
          username: 'UpdateShallNotWork',
          email: admin.email,
          password: 'password'
        }
      }

      updated_obj = User.find admin.id
      expect(updated_obj.email).to eql(admin.email)
      expect(updated_obj.username).to eql(admin.username)
      expect(updated_obj.username).not_to eql('UpdateShallNotWork')
    end

    it 'can destroy selections' do
      delete destroy_selections_ez_on_rails_users_url

      expect(response).to have_http_status(:success)
    end
  end
end
