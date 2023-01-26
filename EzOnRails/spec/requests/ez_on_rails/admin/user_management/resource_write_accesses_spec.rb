# frozen_string_literal: true

require 'rails_helper'

# Spec for testing the access for the actions in Admin::UserManagement::ResourceWriteAccessesController.
# Testing whether a non looged in user (called anonymus here) can not get any action, because the access should
# be denied.
# Testing whether some non admin logged in user (called andrew here) can not get any action, because the access
# should be denied.
# Testing whether admin can get the actions, because the access is granted.
# This spec also tests the basic CRUD functionality of the actions which should Create, Update or Destroy
# ActiveRecord instance.
RSpec.describe 'EzOnRails::Admin::UserManagement::ResourceWriteAccessesController' do
  # users
  let(:andrew) { create(:andrew) }
  let(:admin) { User.super_admin }

  # for test of update, destroy and show actions
  let(:group) do
    create(:eor_group,
           name: 'Group to update its assigned access')
  end
  let(:resource) { create(:user_owned_record, owner: andrew) }
  let(:resource_write_access) do
    create(:eor_resource_write_access,
           group: group,
           resource: resource)
  end

  # for test of create actions
  let(:resource_write_access_attributes) do
    attributes_for(:eor_resource_write_access,
                   group_id: group.id,
                   resource_id: resource.id,
                   resource_type: resource.class.to_s)
  end

  before do
    create(:eor_ownership_info, resource: 'UserOwnedRecord', sharable: true)
  end

  context 'when not logged in' do
    it 'can not get index' do
      get ez_on_rails_resource_write_accesses_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not get search' do
      get search_ez_on_rails_resource_write_accesses_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not search' do
      post search_ez_on_rails_resource_write_accesses_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not get new' do
      get new_ez_on_rails_resource_write_access_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not create resource_write_access' do
      post ez_on_rails_resource_write_accesses_url, params: {
        resource_write_access: resource_write_access_attributes
      }

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not show resource_write_access' do
      get ez_on_rails_resource_write_access_url(resource_write_access)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not get edit' do
      get edit_ez_on_rails_resource_write_access_url(resource_write_access)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not update resource_write_access' do
      other_resource = create(:user_owned_record)

      patch ez_on_rails_resource_write_access_url(resource_write_access),
            params: {
              resource_write_access: {
                resource_id: other_resource.id,
                resource_type: other_resource.class.to_s
              }
            }

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not destroy resource_write_access' do
      delete ez_on_rails_resource_write_access_url(resource_write_access), params: { id: resource_write_access.id }

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not destroy selections' do
      delete destroy_selections_ez_on_rails_resource_write_accesses_url

      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'when logged in as andrew' do
    before do
      sign_in andrew
    end

    it 'can not get index' do
      get ez_on_rails_resource_write_accesses_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not get search' do
      get search_ez_on_rails_resource_write_accesses_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not search' do
      post search_ez_on_rails_resource_write_accesses_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not get new' do
      get new_ez_on_rails_resource_write_access_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not create resource_write_access' do
      post ez_on_rails_resource_write_accesses_url, params: {
        resource_write_access: resource_write_access_attributes
      }

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not show resource_write_access' do
      get ez_on_rails_resource_write_access_url(resource_write_access)

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not get edit' do
      get edit_ez_on_rails_resource_write_access_url(resource_write_access)

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not update resource_write_access' do
      other_resource = create(:user_owned_record)

      patch ez_on_rails_resource_write_access_url(resource_write_access),
            params: {
              resource_write_access: {
                resource_id: other_resource.id,
                resource_type: other_resource.class.to_s
              }
            }

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not destroy resource_write_access' do
      delete ez_on_rails_resource_write_access_url(resource_write_access)

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not destroy selections' do
      delete destroy_selections_ez_on_rails_resource_write_accesses_url

      expect(response).to have_http_status(:forbidden)
    end
  end

  context 'when logged in as admin' do
    before do
      sign_in admin
    end

    it 'can get index' do
      get ez_on_rails_resource_write_accesses_url

      expect(response).to have_http_status(:success)
    end

    it 'can get search' do
      get search_ez_on_rails_resource_write_accesses_url

      expect(response).to have_http_status(:success)
    end

    it 'can search' do
      post search_ez_on_rails_resource_write_accesses_url

      expect(response).to have_http_status(:success)
    end

    it 'can get new' do
      get new_ez_on_rails_resource_write_access_url

      expect(response).to have_http_status(:success)
    end

    it 'can create resource_write_access' do
      post ez_on_rails_resource_write_accesses_url, params: {
        resource_write_access: resource_write_access_attributes
      }

      created_object = EzOnRails::ResourceWriteAccess.last
      expect(created_object.group_id).to eql(group.id)
      expect(created_object.resource_id).to eql(resource.id)
      expect(created_object.resource_type).to eql(resource.class.to_s)
      expect(response).to redirect_to(ez_on_rails_resource_write_access_url(created_object))
    end

    it 'can show resource_write_access' do
      get ez_on_rails_resource_write_access_url(resource_write_access)

      expect(response).to have_http_status(:success)
    end

    it 'can get edit' do
      get edit_ez_on_rails_resource_write_access_url(resource_write_access)

      expect(response).to have_http_status(:success)
    end

    it 'can update resource_write_access' do
      other_resource = create(:user_owned_record)

      patch ez_on_rails_resource_write_access_url(resource_write_access),
            params: {
              resource_write_access: {
                resource_id: other_resource.id,
                resource_type: other_resource.class.to_s
              }
            }

      updated_object = EzOnRails::ResourceWriteAccess.find resource_write_access.id
      expect(updated_object.resource_id).to eql(other_resource.id)
      expect(updated_object.resource_type).to eql(other_resource.class.to_s)

      expect(response).to redirect_to(resource_write_access)
    end

    it 'can destroy resource_write_access' do
      delete ez_on_rails_resource_write_access_url(resource_write_access)

      expect(EzOnRails::ResourceWriteAccess.find_by(id: resource_write_access.id)).to be_nil
      expect(response).to redirect_to(EzOnRails::ResourceWriteAccess)
    end

    it 'can destroy selections' do
      delete destroy_selections_ez_on_rails_resource_write_accesses_url

      expect(response).to have_http_status(:success)
    end
  end
end
