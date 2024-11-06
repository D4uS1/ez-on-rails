# frozen_string_literal: true

require 'rails_helper'

# Spec for testing the access for the actions in Admin::BroomCloset::NilOwnersController.
# Testing whether a non looged in user (called anonymus here) can not get any action, because the access can be denied.
# Testing whether some non admin logged in user (called andrew here) can not get any action,
# because the access can be denied.
# Testing whether admin can get the actions, because the access is granted.
RSpec.describe 'EzOnRails::Admin::BroomCloset::NilOwnersController' do
  # users
  let(:john) { create(:john) }
  let(:andrew) { create(:andrew) }
  let(:admin) { User.super_admin }

  # to test that nil owners are shown
  let(:anonymous_first_record) do
    create(:user_owned_record_without_validation,
           test: 'No ones first group',
           owner: nil)
  end
  let(:anonymous_second_record) do
    create(:user_owned_record_without_validation,
           test: 'No ones second group',
           owner: nil)
  end
  let(:anonymous_third_record) do
    create(:user_owned_record_without_validation,
           test: 'No ones third group',
           owner: nil)
  end

  # to test that valid owners are not shown
  let(:johns_first_record) do
    create(:user_owned_record_without_validation,
           test: 'Johns first resource',
           owner: john)
  end
  let(:johns_second_record) do
    create(:user_owned_record_without_validation,
           test: 'Johns second resource',
           owner: john)
  end
  let(:andrews_first_record) do
    create(:user_owned_record_without_validation,
           test: 'Andrews first resource',
           owner: andrew)
  end
  let(:andrews_second_record) do
    create(:user_owned_record_without_validation,
           test: 'Andrews second resource',
           owner: andrew)
  end

  before do
    create(:eor_ownership_info,
           resource: 'UserOwnedRecord')

    anonymous_first_record
    anonymous_second_record
    anonymous_third_record
    johns_first_record
    johns_second_record
    andrews_first_record
    andrews_second_record
  end

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

      expect(response).to have_http_status(:success)
    end

    it 'can destroy all' do
      delete ez_on_rails_nil_owners_destroy_all_url

      expect(response).to redirect_to(ez_on_rails_nil_owners_url)
    end
  end

  context 'when requesting destroy_selections' do
    before do
      sign_in admin
    end

    it 'destroys selected resources without owner' do
      delete ez_on_rails_nil_owners_destroy_selections_url, params: {
        selections: ActiveSupport::JSON.encode([{ data: {
                                                 id: anonymous_first_record.id,
                                                 type: anonymous_first_record.class.to_s
                                               } }])
      }

      service = EzOnRails::Admin::BroomClosetService.new
      nil_owners = service.nil_owners
      expect(response).to have_http_status(:success)
      expect(nil_owners.length).to eq(2)
      expect(nil_owners).not_to include(anonymous_first_record)
      expect(nil_owners).to include(anonymous_second_record)
      expect(nil_owners).to include(anonymous_third_record)
    end

    it 'does not destroy selected resources with owner' do
      delete ez_on_rails_nil_owners_destroy_selections_url, params: {
        selections: ActiveSupport::JSON.encode([{ data: {
                                                 id: andrews_first_record.id,
                                                 type: andrews_first_record.class.to_s
                                               } }])
      }

      expect(response).to have_http_status(:success)
      expect(andrews_first_record.class.find(andrews_first_record.id)).not_to be_nil
    end
  end

  context 'when requesting destroy_all' do
    before do
      sign_in admin
    end

    it 'destroys all resources without owner' do
      delete ez_on_rails_nil_owners_destroy_all_url

      expect(response).to redirect_to(ez_on_rails_nil_owners_url)

      service = EzOnRails::Admin::BroomClosetService.new
      nil_owners = service.nil_owners
      expect(response).to redirect_to(ez_on_rails_nil_owners_url)
      expect(nil_owners.length).to eq(0)
    end

    it 'does not destroy resources with owner' do
      delete ez_on_rails_nil_owners_destroy_all_url

      expect(response).to redirect_to(ez_on_rails_nil_owners_url)

      all_records = johns_first_record.class.all
      expect(response).to redirect_to(ez_on_rails_nil_owners_url)
      expect(all_records.length).to eq(4)
      expect(all_records).to include(andrews_first_record)
      expect(all_records).to include(andrews_second_record)
      expect(all_records).to include(johns_first_record)
      expect(all_records).to include(johns_second_record)
    end
  end
end
