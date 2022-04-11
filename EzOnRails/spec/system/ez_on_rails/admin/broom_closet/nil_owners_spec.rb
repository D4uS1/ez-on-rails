# frozen_string_literal: true

require 'rails_helper'

# Spec for testing the behavior of the broom closets nil owners capabilities.
# Testing if the admin is able to see and delete ownership infos, which are assigned to
# no user.
RSpec.describe 'Nil Owners user view', type: :system do
  before do
    create(:eor_ownership_info,
           resource: 'UserOwnedRecord')
  end

  # users
  let(:andrew) { create(:andrew) }
  let(:john) { create(:john) }
  let(:admin) { User.super_admin }

  # to test that nil owners are shown
  let!(:anonymous_first_record) do
    create(:user_owned_record_without_validation,
           test: 'No ones first group',
           owner: nil)
  end
  let!(:anonymous_second_record) do
    create(:user_owned_record_without_validation,
           test: 'No ones second group',
           owner: nil)
  end
  let!(:anonymous_third_record) do
    create(:user_owned_record_without_validation,
           test: 'No ones third group',
           owner: nil)
  end

  # to test that valid owners are not shown
  let!(:johns_first_record) do
    create(:user_owned_record_without_validation,
           test: 'Johns first resource',
           owner: john)
  end
  let!(:johns_second_record) do
    create(:user_owned_record_without_validation,
           test: 'Johns second resource',
           owner: john)
  end
  let!(:andrews_first_record) do
    create(:user_owned_record_without_validation,
           test: 'Andrews first resource',
           owner: andrew)
  end
  let!(:andrews_second_record) do
    create(:user_owned_record_without_validation,
           test: 'Andrews second resource',
           owner: andrew)
  end

  context 'when logged in as admin' do
    before do
      system_log_in User.super_admin.email, '1replace_me3_after3_install7'
    end

    it 'can not see owned resources' do
      visit 'ez_on_rails/admin/broom_closet/nil_owners/'

      expect(page).not_to have_css 'td', text: /\A#{johns_first_record.id}\z/
      expect(page).not_to have_css 'td', text: /\A#{johns_second_record.id}\z/
      expect(page).not_to have_css 'td', text: /\A#{andrews_first_record.id}\z/
      expect(page).not_to have_css 'td', text: /\A#{andrews_second_record.id}\z/
    end

    it 'can see nil owned resources' do
      visit 'ez_on_rails/admin/broom_closet/nil_owners/'

      expect(page).to have_css 'td', text: /\A#{anonymous_first_record.id}\z/
      expect(page).to have_css 'td', text: /\A#{anonymous_second_record.id}\z/
      expect(page).to have_css 'td', text: /\A#{anonymous_third_record.id}\z/
    end

    it 'deletes one nil owned resource' do
      visit 'ez_on_rails/admin/broom_closet/nil_owners/'

      first('#enhanced_table_select_row_enhanced_table').check
      click_on t(:'ez_on_rails.destroy_selection')
      system_confirm_modal
      system_wait_for_flash_message

      expect(page).to have_text t(:'ez_on_rails.nil_owners_success')
      expect(page).not_to have_css 'td', text: /\A#{anonymous_first_record.id}\z/
      expect(page).to have_css 'td', text: /\A#{anonymous_second_record.id}\z/
      expect(page).to have_css 'td', text: /\A#{anonymous_third_record.id}\z/
    end

    it 'deletes all nil owned resources' do
      visit 'ez_on_rails/admin/broom_closet/nil_owners/'

      click_on t(:'ez_on_rails.destroy_all')
      system_confirm_modal
      system_wait_for_flash_message

      expect(page).to have_text t(:'ez_on_rails.nil_owners_success')
      expect(page).not_to have_css 'td', text: /\A#{anonymous_first_record.id}\z/
      expect(page).not_to have_css 'td', text: /\A#{anonymous_second_record.id}\z/
      expect(page).not_to have_css 'td', text: /\A#{anonymous_third_record.id}\z/
    end
  end
end
