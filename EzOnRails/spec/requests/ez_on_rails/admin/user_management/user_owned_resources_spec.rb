# frozen_string_literal: true

require 'rails_helper'

# Spec for testing the access for the actions in Admin::UserManagement::OwnershipInfosController.
# Testing whether a non looged in user (called anonymus here) can not get any action, because the access
# should be denied.
# Testing whether some non admin logged in user (called andrew here) can not get any action, because the
# access should be denied.
# Testing whether admin can get the actions, because the access is granted.
# This spec also tests the basic CRUD functionality of the actions which should Create, Update or Destroy
# ActiveRecord instance.
RSpec.describe 'EzOnRails::Admin::UserManagement::OwnershipInfosController' do
  # users
  let(:andrew) { create(:andrew) }
  let(:admin) { User.super_admin }

  # for show, update and destroy actions
  let(:ownership_info) do
    create(:eor_ownership_info,
           resource: 'EzOnRails::Group')
  end

  # for create action
  let(:ownership_info_create) do
    build(:eor_ownership_info,
          resource: 'EzOnRails::OwnershipInfo')
  end

  context 'when not logged in' do
    it 'can not get index' do
      get ez_on_rails_ownership_infos_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not get search' do
      get search_ez_on_rails_ownership_infos_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not search' do
      post search_ez_on_rails_ownership_infos_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not get new' do
      get new_ez_on_rails_ownership_info_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not create ownership_info' do
      post ez_on_rails_ownership_infos_url, params: {
        ownership_info: {
          resource: ownership_info_create.resource,
          owner_id: ownership_info_create.owner_id
        }
      }

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not show ownership_info' do
      get ez_on_rails_ownership_info_url(ownership_info)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not get edit' do
      get edit_ez_on_rails_ownership_info_url(ownership_info)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not update ownership_info' do
      patch ez_on_rails_ownership_info_url(ownership_info), params: {
        ownership_info: {
          owner_id: ownership_info.owner_id,
          resource: ownership_info.resource
        }
      }

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not destroy ownership_info' do
      delete ez_on_rails_ownership_info_url(ownership_info)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not destroy selections' do
      delete destroy_selections_ez_on_rails_ownership_infos_url

      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'when logged in as andrew' do
    before do
      sign_in andrew
    end

    it 'can not get index' do
      get ez_on_rails_ownership_infos_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not get search' do
      get search_ez_on_rails_ownership_infos_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not search' do
      post search_ez_on_rails_ownership_infos_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not get new' do
      get new_ez_on_rails_ownership_info_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not create ownership_info' do
      post ez_on_rails_ownership_infos_url, params: {
        ownership_info: {
          resource: ownership_info_create.resource,
          owner_id: ownership_info_create.owner_id
        }
      }

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not show ownership_info' do
      get ez_on_rails_ownership_info_url(ownership_info)

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not get edit' do
      get edit_ez_on_rails_ownership_info_url(ownership_info)

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not update ownership_info' do
      patch ez_on_rails_ownership_info_url(ownership_info), params: {
        ownership_info: {
          owner_id: ownership_info.owner_id,
          resource: ownership_info.resource
        }
      }

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not destroy ownership_info' do
      delete ez_on_rails_ownership_info_url(ownership_info)

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not destroy selections' do
      delete destroy_selections_ez_on_rails_ownership_infos_url

      expect(response).to have_http_status(:forbidden)
    end
  end

  context 'when logged in as admin' do
    before do
      sign_in admin
    end

    it 'can get index' do
      get ez_on_rails_ownership_infos_url

      expect(response).to have_http_status(:success)
    end

    it 'can get search' do
      get search_ez_on_rails_ownership_infos_url

      expect(response).to have_http_status(:success)
    end

    it 'can search' do
      post search_ez_on_rails_ownership_infos_url

      expect(response).to have_http_status(:success)
    end

    it 'can get new' do
      get new_ez_on_rails_ownership_info_url

      expect(response).to have_http_status(:success)
    end

    it 'can create ownership_info' do
      post ez_on_rails_ownership_infos_url, params: {
        ownership_info: {
          resource: ownership_info_create.resource,
          owner_id: ownership_info_create.owner_id
        }
      }

      created_object = EzOnRails::OwnershipInfo.last
      expect(created_object.resource).to eql(ownership_info_create.resource)
      expect(response).to redirect_to(EzOnRails::OwnershipInfo.last)
    end

    it 'can show ownership_info' do
      get ez_on_rails_ownership_info_url(ownership_info)

      expect(response).to have_http_status(:success)
    end

    it 'can get edit' do
      get edit_ez_on_rails_ownership_info_url(ownership_info)

      expect(response).to have_http_status(:success)
    end

    it 'can update ownership_info' do
      patch ez_on_rails_ownership_info_url(ownership_info), params: {
        ownership_info: {
          owner_id: ownership_info.owner_id,
          resource: 'EzOnRails::UserGroupAssignment'
        }
      }

      updated_object = EzOnRails::OwnershipInfo.find ownership_info.id
      expect(updated_object.resource).to eql('EzOnRails::UserGroupAssignment')
      expect(updated_object.owner_id).to eql(ownership_info.owner_id)

      expect(response).to redirect_to(ownership_info)
    end

    it 'can destroy ownership_info' do
      delete ez_on_rails_ownership_info_url(ownership_info)

      expect(EzOnRails::OwnershipInfo.find_by(id: ownership_info.id)).to be_nil
      expect(response).to redirect_to(EzOnRails::OwnershipInfo)
    end

    it 'can destroy selections' do
      delete destroy_selections_ez_on_rails_ownership_infos_url

      expect(response).to have_http_status(:success)
    end
  end
end
