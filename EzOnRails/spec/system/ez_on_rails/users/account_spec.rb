# frozen_string_literal: true

require 'rails_helper'

# Spec for testing account behaviors.
# Testing that some user (called andrew here) can edit and destroy its account.
# Also Testing that the admin user can not destroy its account, but update its account.
RSpec.describe 'User Account' do
  let(:admin) { User.super_admin }
  let!(:andrew) { create(:andrew) }

  context 'when logged in as andrew' do
    before do
      system_log_in andrew.email, 'andrewandrew'
    end

    it 'can not update its account using the wrong password' do
      visit '/users/edit'

      fill_in 'user_email', with: 'new@test.mail'
      fill_in 'user_current_password', with: 'totallyWrongPassword'
      click_on t(:'ez_on_rails.save')

      expect(page).not_to have_text t('devise.registrations.updated')
      updated_object = User.find andrew.id
      expect(updated_object.email).to eql(andrew.email)
    end

    it 'can update its account using the correct password' do
      visit '/users/edit'

      fill_in 'user_username', with: 'NewUsername'
      fill_in 'user_current_password', with: 'andrewandrew'
      click_on t(:'ez_on_rails.save')

      expect(page).to have_text t('devise.registrations.updated')
      updated_object = User.find andrew.id
      expect(updated_object.username).to eql('NewUsername')
    end

    it 'can update its email using the correct password and sees message for needed confirmation' do
      visit '/users/edit'

      fill_in 'user_email', with: 'new@test.mail'
      fill_in 'user_current_password', with: 'andrewandrew'
      click_on t(:'ez_on_rails.save')

      expect(page).to have_text t('devise.registrations.update_needs_confirmation')
      updated_object = User.find andrew.id
      expect(updated_object.unconfirmed_email).to eql('new@test.mail')
    end

    it 'can not delete its account using the wrong password' do
      visit '/users/edit'

      handle_confirm do
        fill_in 'user_current_password', with: 'totallyWrongPassword'
        click_on t(:remove_account)
      end

      expect(page).not_to have_text t('devise.registrations.destroyed')
      expect(User.find_by(id: andrew.id)).not_to be_nil
    end

    it 'can delete its account using the correct password' do
      visit '/users/edit'

      handle_confirm do
        fill_in 'user_current_password', with: 'andrewandrew'
        click_on t(:remove_account)
      end

      expect(page).to have_text t(:'devise.registrations.destroyed')
      expect(User.find_by(id: andrew.id)).to be_nil
    end
  end

  context 'when logged in as admin' do
    before do
      system_log_in User.super_admin.email, '1replace_me3_after3_install7'
    end

    it 'can not update its account using the wrong password' do
      visit '/users/edit'

      fill_in 'user_email', with: 'new@test.mail'
      fill_in 'user_current_password', with: 'totallyWrongPassword'
      click_on t(:'ez_on_rails.save')

      expect(page).not_to have_text t('devise.registrations.updated')
      updated_object = User.find admin.id
      expect(updated_object.email).to eql(admin.email)
    end

    it 'can update its email using the correct password and gets message to confirm it' do
      visit '/users/edit'

      fill_in 'user_email', with: 'new@test.mail'
      fill_in 'user_current_password', with: '1replace_me3_after3_install7'
      click_on t(:'ez_on_rails.save')

      expect(page).to have_text t('devise.registrations.update_needs_confirmation')
      updated_object = User.find admin.id
      expect(updated_object.unconfirmed_email).to eql('new@test.mail')
    end

    it 'can not update its username using the correct password' do
      visit '/users/edit'

      fill_in 'user_username', with: 'UpdateShallNotWork'
      fill_in 'user_current_password', with: '1replace_me3_after3_install7'
      click_on t(:'ez_on_rails.save')

      expect(page).to have_text t(:admin_user_not_updatable)
      updated_object = User.find admin.id
      expect(updated_object.username).to eql(User::SUPER_ADMIN_USERNAME)
    end

    it 'can not delete its account' do
      visit '/users/edit'

      handle_confirm do
        fill_in 'user_current_password', with: '1replace_me3_after3_install7'
        click_on t(:remove_account)
      end

      expect(page).not_to have_text t('devise.registrations.destroyed')
      expect(page).to have_text t(:admin_user_not_destroyable)
      expect(User.find_by(id: admin.id)).not_to be_nil
    end
  end
end
