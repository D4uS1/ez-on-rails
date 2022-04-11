# frozen_string_literal: true

require 'rails_helper'

# Spec for testing the access for the actions in Admin::UserManagement::UserGroupAccessesController.
# Testing whether a non looged in user (called anonymus here) can not get any action, because the access should
# be denied.
# Testing whether some non admin logged in user (called andrew here) can not get any action, because the access
# should be denied.
# Testing whether admin can get the actions, because the access is granted.
# This spec also tests the basic CRUD functionality of the actions which should Create, Update or Destroy
# ActiveRecord instance.
RSpec.describe 'ez_on_rails/admin/user_management/group_accesses', type: :request do
  # users
  let(:andrew) { create(:andrew) }
  let(:admin) { User.super_admin }

  # for test of update, destroy and show actions
  let(:group) do
    create(:eor_group,
           name: 'Group to update its assigned access')
  end
  let(:group_access) do
    create(:eor_group_access,
           namespace: 'ez_on_rails/admin/broom_closet',
           controller: 'nil_owners',
           action: 'index',
           group: group)
  end

  # for test of create actions
  let(:group_create) do
    create(:eor_group,
           name: 'Group to create an assigned access')
  end
  let(:group_access_create) do
    build(:eor_group_access,
          namespace: 'ez_on_rails/admin/broom_closet',
          controller: 'unattached_files',
          action: 'index',
          group: group_create)
  end

  context 'when not logged in' do
    it 'can not get index' do
      get ez_on_rails_group_accesses_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not get search' do
      get search_ez_on_rails_group_accesses_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not search' do
      post search_ez_on_rails_group_accesses_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not get new' do
      get new_ez_on_rails_group_access_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not create group_access' do
      post ez_on_rails_group_accesses_url, params: {
        group_access: {
          group_id: group_access_create.group_id,
          action: group_access_create.action,
          controller: group_access_create.controller,
          namespace: group_access_create.namespace,
          owner_id: group_access_create.owner_id
        }
      }

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not show group_access' do
      get ez_on_rails_group_access_url(group_access)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not get edit' do
      get edit_ez_on_rails_group_access_url(group_access)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not update group_access' do
      patch ez_on_rails_group_access_url(group_access),
            params: {
              group_access: {
                action: group_access.action,
                controller: group_access.controller,
                namespace: group_access.namespace,
                owner_id: group_access.owner_id
              }
            }

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not destroy group_access' do
      delete ez_on_rails_group_access_url(group_access), params: { id: group_access.id }

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not destroy selections' do
      delete destroy_selections_ez_on_rails_group_accesses_url

      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'when logged in as andrew' do
    before do
      sign_in andrew
    end

    it 'can not get index' do
      get ez_on_rails_group_accesses_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not get search' do
      get search_ez_on_rails_group_accesses_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not search' do
      post search_ez_on_rails_group_accesses_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not get new' do
      get new_ez_on_rails_group_access_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not create group_access' do
      post ez_on_rails_group_accesses_url, params: {
        group_access: {
          group_id: group_access_create.group_id,
          action: group_access_create.action,
          controller: group_access_create.controller,
          namespace: group_access_create.namespace,
          owner_id: group_access_create.owner_id
        }
      }

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not show group_access' do
      get ez_on_rails_group_access_url(group_access)

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not get edit' do
      get edit_ez_on_rails_group_access_url(group_access)

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not update group_access' do
      patch ez_on_rails_group_access_url(group_access),
            params: {
              group_access: {
                action: group_access.action,
                controller: group_access.controller,
                namespace: group_access.namespace,
                owner_id: group_access.owner_id
              }
            }

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not destroy group_access' do
      delete ez_on_rails_group_access_url(group_access)

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not destroy selections' do
      delete destroy_selections_ez_on_rails_group_accesses_url

      expect(response).to have_http_status(:forbidden)
    end
  end

  context 'when logged in as admin' do
    before do
      sign_in admin
    end

    it 'can get index' do
      get ez_on_rails_group_accesses_url

      expect(response).to have_http_status(:success)
    end

    it 'can get search' do
      get search_ez_on_rails_group_accesses_url

      expect(response).to have_http_status(:success)
    end

    it 'can search' do
      post search_ez_on_rails_group_accesses_url

      expect(response).to have_http_status(:success)
    end

    it 'can get new' do
      get new_ez_on_rails_group_access_url

      expect(response).to have_http_status(:success)
    end

    it 'can create group_access' do
      post ez_on_rails_group_accesses_url, params: {
        group_access: {
          group_id: group_access_create.group_id,
          action: group_access_create.action,
          controller: group_access_create.controller,
          namespace: group_access_create.namespace,
          owner_id: group_access_create.owner_id
        }
      }

      created_object = EzOnRails::GroupAccess.last
      expect(created_object.group_id).to eql(group_create.id)
      expect(created_object.action).to eql(group_access_create.action)
      expect(created_object.controller).to eql(group_access_create.controller)
      expect(created_object.namespace).to eql(group_access_create.namespace)
      expect(response).to redirect_to(ez_on_rails_group_access_url(created_object))
    end

    it 'can show group_access' do
      get ez_on_rails_group_access_url(group_access)

      expect(response).to have_http_status(:success)
    end

    it 'can get edit' do
      get edit_ez_on_rails_group_access_url(group_access)

      expect(response).to have_http_status(:success)
    end

    it 'can update group_access' do
      patch ez_on_rails_group_access_url(group_access),
            params: {
              group_access: {
                namespace: EzOnRails::GroupAccess::ADMIN_AREA_NAMESPACE,
                controller: 'dashboard',
                action: 'index'
              }
            }

      updated_object = EzOnRails::GroupAccess.find group_access.id
      expect(updated_object.action).to eql('index')
      expect(updated_object.controller).to eql('dashboard')
      expect(updated_object.namespace).to eql(EzOnRails::GroupAccess::ADMIN_AREA_NAMESPACE)
      expect(updated_object.owner_id).to eql(group_access.owner_id)

      expect(response).to redirect_to(group_access)
    end

    it 'can destroy group_access' do
      delete ez_on_rails_group_access_url(group_access)

      expect(EzOnRails::GroupAccess.find_by(id: group_access.id)).to be_nil
      expect(response).to redirect_to(EzOnRails::GroupAccess)
    end

    it 'can not destroy group_access of admin area' do
      delete ez_on_rails_group_access_url(EzOnRails::GroupAccess.admin_area)

      expect(EzOnRails::GroupAccess.admin_area).not_to be_nil
    end

    it 'can not update group_access of admin area' do
      access = EzOnRails::GroupAccess.admin_area

      patch ez_on_rails_group_access_url(access),
            params: {
              group_access: {
                namespace: EzOnRails::GroupAccess::ADMIN_AREA_NAMESPACE,
                controller: 'dashboard',
                action: 'index'
              }
            }

      updated_obj = EzOnRails::GroupAccess.find access.id
      expect(updated_obj.namespace).to eql(access.namespace)
      expect(updated_obj.controller).to eql(access.controller)
      expect(updated_obj.action).to eql(access.action)
    end

    it 'can destroy selections' do
      delete destroy_selections_ez_on_rails_group_accesses_url

      expect(response).to redirect_to(ez_on_rails_group_accesses_url)
    end
  end
end
