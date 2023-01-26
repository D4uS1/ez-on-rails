# frozen_string_literal: true

require 'rails_helper'

# Spec for testing the access for the actions in Admin::BroomCloset::NilOwnersController.
# Testing whether a non looged in user (called anonymus here) can not get any action, because the access can be denied.
# Testing whether some non admin logged in user (called andrew here) can not get any action,
# because the access can be denied.
# Testing whether admin can get the actions, because the access is granted.
RSpec.describe 'EzOnRails::Admin::BroomCloset::NilOwnersController' do
  # users
  let(:andrew) { create(:andrew) }
  let(:admin) { User.super_admin }

  context 'when not logged in' do
    it 'can not get index' do
      get ez_on_rails_nil_owners_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not get search' do
      get ez_on_rails_nil_owners_search_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not search' do
      post ez_on_rails_nil_owners_search_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not destroy selections' do
      delete ez_on_rails_nil_owners_destroy_selections_url

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not destroy all' do
      delete ez_on_rails_nil_owners_destroy_all_url

      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'when logged in as andrew' do
    before do
      sign_in andrew
    end

    it 'can not get index' do
      get ez_on_rails_nil_owners_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not get search' do
      get ez_on_rails_nil_owners_search_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not search' do
      post ez_on_rails_nil_owners_search_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not destroy selections' do
      delete ez_on_rails_nil_owners_destroy_selections_url

      expect(response).to have_http_status(:forbidden)
    end

    it 'can not destroy all' do
      delete ez_on_rails_nil_owners_destroy_all_url

      expect(response).to have_http_status(:forbidden)
    end
  end

  context 'when logged in as admin' do
    before do
      sign_in admin
    end

    it 'can get index' do
      get ez_on_rails_nil_owners_url

      expect(response).to have_http_status(:success)
    end

    it 'can get search' do
      get ez_on_rails_nil_owners_search_url

      expect(response).to have_http_status(:success)
    end

    it 'can search' do
      post ez_on_rails_nil_owners_search_url

      expect(response).to have_http_status(:success)
    end

    it 'can destroy selections' do
      delete ez_on_rails_nil_owners_destroy_selections_url

      expect(response).to redirect_to(ez_on_rails_nil_owners_url)
    end

    it 'can destroy all' do
      delete ez_on_rails_nil_owners_destroy_all_url

      expect(response).to redirect_to(ez_on_rails_nil_owners_url)
    end
  end
end
