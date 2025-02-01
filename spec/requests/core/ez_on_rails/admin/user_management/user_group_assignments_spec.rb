# frozen_string_literal: true

require 'rails_helper'

# Spec for testing the access for the actions in Admin::UserManagement::UserGroupAssignmentsController.
# Testing whether a non looged in user (called anonymus here) can not get any action, because the access
# should be denied.
# Testing whether some non admin logged in user (called andrew here) can not get any action, because the
# access should be denied.
# Testing whether admin can get the actions, because the access is granted.
# This spec also tests the basic CRUD functionality of the actions which should Create, Update or Destroy
# ActiveRecord instance.
RSpec.describe 'EzOnRails::Admin::UserManagement::UserGroupAssignmentsController' do
  # users
  let(:andrew) { create(:andrew) }
  let(:admin) { User.super_admin }

  # for update, show and destroy
  let(:user) do
    create(:bob)
  end

  let(:group) do
    create(:eor_group,
           name: 'Group to update its assignment')
  end
  let(:user_group_assignment) do
    create(:eor_user_group_assignment,
           user:,
           group:)
  end

  # for create
  let(:user_create) do
    create(:user,
           username: 'UserForAssignmentCreation',
           email: 'create@me.com',
           password: 'createcreate')
  end
  let(:group_create) do
    create(:eor_group,
           name: 'Group to create an assignment')
  end
  let(:user_group_assignment_create) do
    build(:eor_user_group_assignment,
          user:,
          group: group_create)
  end

  context 'when not logged in' do
    it 'can not get index' do
      get ez_on_rails_user_group_assignments_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not get search' do
      get search_ez_on_rails_user_group_assignments_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not search' do
      post search_ez_on_rails_user_group_assignments_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not get new' do
      get new_ez_on_rails_user_group_assignment_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not create user_group_assignment' do
      post ez_on_rails_user_group_assignments_url, params: {
        user_group_assignment: {
          owner_id: user_group_assignment_create.owner_id,
          group_id: user_group_assignment_create.group_id,
          user_id: user_group_assignment_create.user_id
        }
      }

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not show user_group_assignment' do
      get ez_on_rails_user_group_assignment_url(user_group_assignment)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not get edit' do
      get edit_ez_on_rails_user_group_assignment_url(user_group_assignment)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not update user_group_assignment' do
      patch ez_on_rails_user_group_assignment_url(user_group_assignment), params: {
        user_group_assignment: {
          owner_id: user_group_assignment.owner_id,
          group_id: user_group_assignment.group_id,
          user_id: user_group_assignment.user_id
        }
      }

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not destroy user_group_assignment' do
      delete ez_on_rails_user_group_assignment_url(user_group_assignment)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not destroy selections' do
      delete destroy_selections_ez_on_rails_user_group_assignments_url

      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'when logged in as andrew' do
    before do
      sign_in andrew
    end

    it 'can not get index' do
      get ez_on_rails_user_group_assignments_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not get search' do
      get search_ez_on_rails_user_group_assignments_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not search' do
      post search_ez_on_rails_user_group_assignments_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not get new' do
      get new_ez_on_rails_user_group_assignment_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not create user_group_assignment' do
      post ez_on_rails_user_group_assignments_url, params: {
        user_group_assignment: {
          owner_id: user_group_assignment_create.owner_id,
          group_id: user_group_assignment_create.group_id,
          user_id: user_group_assignment_create.user_id
        }
      }

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not show user_group_assignment' do
      get ez_on_rails_user_group_assignment_url(user_group_assignment)

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not get edit' do
      get edit_ez_on_rails_user_group_assignment_url(user_group_assignment)

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not update user_group_assignment' do
      patch ez_on_rails_user_group_assignment_url(user_group_assignment), params: {
        user_group_assignment: {
          owner_id: user_group_assignment.owner_id,
          group_id: user_group_assignment.group_id,
          user_id: user_group_assignment.user_id
        }
      }

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not destroy user_group_assignment' do
      delete ez_on_rails_user_group_assignment_url(user_group_assignment)

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not destroy selections' do
      delete destroy_selections_ez_on_rails_user_group_assignments_url

      expect(response).to have_http_status(:forbidden)
    end
  end

  context 'when logged in as admin' do
    before do
      sign_in admin
    end

    it 'can get index' do
      get ez_on_rails_user_group_assignments_url

      expect(response).to have_http_status(:success)
    end

    it 'can get search' do
      get search_ez_on_rails_user_group_assignments_url

      expect(response).to have_http_status(:success)
    end

    it 'can search' do
      post search_ez_on_rails_user_group_assignments_url

      expect(response).to have_http_status(:success)
    end

    it 'can get new' do
      get new_ez_on_rails_user_group_assignment_url

      expect(response).to have_http_status(:success)
    end

    it 'can create user_group_assignment' do
      post ez_on_rails_user_group_assignments_url, params: {
        user_group_assignment: {
          owner_id: user_group_assignment_create.owner_id,
          group_id: user_group_assignment_create.group_id,
          user_id: user_group_assignment_create.user_id
        }
      }

      created_object = EzOnRails::UserGroupAssignment.last
      expect(created_object.user_id).to eql(user_group_assignment_create.user_id)
      expect(created_object.group_id).to eql(user_group_assignment_create.group_id)
      expect(response).to redirect_to(ez_on_rails_user_group_assignment_url(created_object))
    end

    it 'can show user_group_assignment' do
      get ez_on_rails_user_group_assignment_url(user_group_assignment), params: { id: user_group_assignment.id }

      expect(response).to have_http_status(:success)
    end

    it 'can get edit' do
      get edit_ez_on_rails_user_group_assignment_url(user_group_assignment)

      expect(response).to have_http_status(:success)
    end

    it 'can update user_group_assignment' do
      patch ez_on_rails_user_group_assignment_url(user_group_assignment), params: {
        user_group_assignment: {
          owner_id: user_group_assignment.owner_id,
          group_id: user_group_assignment.group_id,
          user_id: andrew.id
        }
      }

      updated_object = EzOnRails::UserGroupAssignment.find user_group_assignment.id
      expect(updated_object.user_id).to eql(andrew.id)
      expect(updated_object.group_id).to eql(user_group_assignment.group_id)
      expect(updated_object.owner_id).to eql(user_group_assignment.owner_id)

      expect(response).to redirect_to(ez_on_rails_user_group_assignment_url(updated_object))
    end

    it 'can destroy user_group_assignment' do
      delete ez_on_rails_user_group_assignment_url(user_group_assignment)

      expect(EzOnRails::UserGroupAssignment.find_by(id: user_group_assignment.id)).to be_nil
      expect(response).to redirect_to(EzOnRails::UserGroupAssignment)
    end

    it 'can not destroy user_group_assignment of admin' do
      assignment = EzOnRails::UserGroupAssignment.super_admin_assignment

      delete ez_on_rails_user_group_assignment_url(assignment)

      expect(EzOnRails::UserGroupAssignment.find_by(id: assignment.id)).not_to be_nil
    end

    it 'can not update user_group_assignment of admin' do
      assignment = EzOnRails::UserGroupAssignment.super_admin_assignment

      patch ez_on_rails_user_group_assignment_url(assignment), params: {
        user_group_assignment: {
          group_id: assignment.group_id,
          user_id: andrew.id
        }
      }

      updated_obj = EzOnRails::UserGroupAssignment.find assignment.id
      expect(updated_obj.group_id).to eql(assignment.group_id)
      expect(updated_obj.user_id).to eql(assignment.user_id)
    end

    it 'can not destroy user_group_assignment of member' do
      assignment = EzOnRails::UserGroupAssignment.find_by(user: andrew, group: EzOnRails::Group.member_group)

      delete ez_on_rails_user_group_assignment_url(assignment)

      expect(EzOnRails::UserGroupAssignment.find_by(id: assignment.id)).not_to be_nil
    end

    it 'can destroy selections' do
      delete destroy_selections_ez_on_rails_user_group_assignments_url

      expect(response).to have_http_status(:success)
    end
  end
end
