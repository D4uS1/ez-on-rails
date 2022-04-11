# frozen_string_literal: true

require 'rails_helper'

# Spec for testing the access for the actions in Admin::UserManagement::UserGroupsController.
# Testing whether a non looged in user (called anonymus here) can not get any action, because the access
# should be denied.
# Testing whether some non admin logged in user (called andrew here) can not get any action, because the access should
# be denied.
# Testing whether admin can get the actions, because the access is granted.
# This spec also tests the basic CRUD functionality of the actions which should Create, Update or Destroy ActiveRecord
# instance.
RSpec.describe 'ez_on_rails/admin/user_management/groups', type: :request do
  # users
  let(:andrew) { create(:andrew) }
  let(:admin) { User.super_admin }

  # for show, update and destroy actions
  let(:group) do
    create(:eor_group,
           name: 'Group to update')
  end

  # for create actions
  let(:group_create) do
    build(:eor_group,
          name: 'Group to create')
  end

  context 'when not logged in' do
    it 'can not get index' do
      get ez_on_rails_groups_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not get search' do
      get search_ez_on_rails_groups_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not search' do
      post search_ez_on_rails_groups_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not get new' do
      get new_ez_on_rails_group_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not create group' do
      post ez_on_rails_groups_url, params: {
        group: {
          name: group_create.name
        }
      }

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not show group' do
      get ez_on_rails_group_url(group)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not get edit' do
      get edit_ez_on_rails_group_url(group)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not update group' do
      patch ez_on_rails_group_url(group), params: {
        group: {
          name: group.name,
          owner_id: group.owner_id
        }
      }

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not destroy group' do
      delete ez_on_rails_group_url(group)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not destroy selections' do
      delete destroy_selections_ez_on_rails_groups_url

      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'when logged in as andrew' do
    before do
      sign_in andrew
    end

    it 'can not get index' do
      get ez_on_rails_groups_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not get search' do
      get search_ez_on_rails_groups_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not search' do
      post search_ez_on_rails_groups_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not get new' do
      get new_ez_on_rails_group_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not create group' do
      post ez_on_rails_groups_url, params: {
        group: {
          name: group_create.name
        }
      }

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not show group' do
      get ez_on_rails_group_url(group)

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not get edit' do
      get edit_ez_on_rails_group_url(group)

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not update group' do
      patch ez_on_rails_group_url(group), params: {
        group: {
          name: group.name,
          owner_id: group.owner_id
        }
      }

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not destroy group' do
      delete ez_on_rails_group_url(group)

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not destroy selections' do
      delete destroy_selections_ez_on_rails_groups_url

      expect(response).to have_http_status(:forbidden)
    end
  end

  context 'when logged in as admin' do
    before do
      sign_in admin
    end

    it 'can get index' do
      get ez_on_rails_groups_url

      expect(response).to have_http_status(:success)
    end

    it 'can get search' do
      get search_ez_on_rails_groups_url

      expect(response).to have_http_status(:success)
    end

    it 'can search' do
      post search_ez_on_rails_groups_url

      expect(response).to have_http_status(:success)
    end

    it 'can get new' do
      get new_ez_on_rails_group_url

      expect(response).to have_http_status(:success)
    end

    it 'can create group' do
      post ez_on_rails_groups_url, params: {
        group: {
          name: group_create.name
        }
      }

      created_object = EzOnRails::Group.last
      expect(created_object.name).to eql(group_create.name)
      expect(response).to redirect_to(EzOnRails::Group.last)
    end

    it 'can show group' do
      get ez_on_rails_group_url(group)

      expect(response).to have_http_status(:success)
    end

    it 'can get edit' do
      get edit_ez_on_rails_group_url(group)

      expect(response).to have_http_status(:success)
    end

    it 'can update group' do
      patch ez_on_rails_group_url(group), params: {
        group: {
          name: 'Updated Group',
          owner_id: group.owner_id
        }
      }

      updated_object = EzOnRails::Group.find group.id
      expect(updated_object.name).to eql('Updated Group')
      expect(updated_object.owner_id).to eql(group.owner_id)

      expect(response).to redirect_to(group)
    end

    it 'can destroy group' do
      delete ez_on_rails_group_url(group)

      expect(EzOnRails::Group.find_by(id: group.id)).to be_nil
      expect(response).to redirect_to(EzOnRails::Group)
    end

    it 'can not destroy group of admin area' do
      group = EzOnRails::Group.super_admin_group

      delete ez_on_rails_group_url(group)

      expect(EzOnRails::Group.find_by(id: group.id)).not_to be_nil
    end

    it 'can not update group of admin area' do
      group = EzOnRails::Group.super_admin_group

      patch ez_on_rails_group_url(group), params: {
        group: {
          name: 'UpdateShallNotWork',
          owner_id: group.owner_id
        }
      }

      updated_obj = EzOnRails::Group.find group.id
      expect(updated_obj.name).to eql(group.name)
      expect(updated_obj.name).not_to eql('UpdateShallNotWork')
    end

    it 'can not destroy group of member' do
      group = EzOnRails::Group.member_group

      delete ez_on_rails_group_url(group)

      expect(EzOnRails::Group.find_by(id: group.id)).not_to be_nil
    end

    it 'can destroy selections' do
      delete destroy_selections_ez_on_rails_groups_url

      expect(response).to redirect_to(ez_on_rails_groups_url)
    end
  end
end
