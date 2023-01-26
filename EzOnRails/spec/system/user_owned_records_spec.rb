# frozen_string_literal: true

require 'rails_helper'

# Spec for testing the bevahior of ownership infos.
# testing whether the user (called andrew here) is able to see his own owned resources and those who
# are not assigned to any user.
# Also testing whether andrew can not see the resources of another user (called john here).
# Also testing whether a non logged in user (called anonymus here) is not able to see any resources
# but those who are not assigned to anyone.
# Also testing whether the admin can see al resources.
RSpec.describe 'ownership info access user view' do
  let(:andrew) { create(:andrew) }
  let!(:anonymous_first_record) do
    create(:user_owned_record,
           test: 'No ones first record',
           owner: nil)
  end
  let!(:anonymous_second_record) do
    create(:user_owned_record,
           test: 'No ones second record',
           owner: nil)
  end
  let!(:johns_first_record) do
    create(:user_owned_record,
           test: 'Johns first resource',
           owner: john)
  end
  let!(:johns_second_record) do
    create(:user_owned_record,
           test: 'Johns second resource',
           owner: john)
  end
  let!(:andrews_first_record) do
    create(:user_owned_record,
           test: 'Andrews first resource',
           owner: andrew)
  end
  let!(:andrews_second_record) do
    create(:user_owned_record,
           test: 'Andrews second resource',
           owner: andrew)
  end
  let(:john) { create(:john) }

  before do
    create(:eor_ownership_info,
           resource: 'UserOwnedRecord')
  end

  # to test that nil owners are shown

  # to test that owned resources are shown only to its users

  context 'when not logged in' do
    it 'can not see owned resources' do
      visit '/user_owned_records'

      expect(page).not_to have_text johns_first_record.test
      expect(page).not_to have_text johns_second_record.test
      expect(page).not_to have_text andrews_first_record.test
      expect(page).not_to have_text andrews_second_record.test
    end

    it 'can see anonymus resources' do
      visit '/user_owned_records'

      expect(page).to have_text anonymous_first_record.test
      expect(page).to have_text anonymous_second_record.test
    end
  end

  context 'when logged in as andrew' do
    before do
      system_log_in andrew.email, 'andrewandrew'
    end

    it 'can see his owned resources' do
      visit '/user_owned_records'

      expect(page).to have_text andrews_first_record.test
      expect(page).to have_text andrews_second_record.test
    end

    it 'can not see other users resources' do
      visit '/user_owned_records'

      expect(page).not_to have_text johns_first_record.test
      expect(page).not_to have_text johns_second_record.test
    end

    it 'can see anonymus resources' do
      visit '/user_owned_records'

      expect(page).to have_text anonymous_first_record.test
      expect(page).to have_text anonymous_second_record.test
    end
  end

  context 'when logged in as admin' do
    before do
      system_log_in User.super_admin.email, '1replace_me3_after3_install7'
    end

    it 'can see all resources' do
      visit '/user_owned_records'

      expect(page).to have_text anonymous_first_record.test
      expect(page).to have_text anonymous_second_record.test
      expect(page).to have_text andrews_first_record.test
      expect(page).to have_text andrews_second_record.test
      expect(page).to have_text johns_first_record.test
      expect(page).to have_text johns_second_record.test
    end
  end
end
