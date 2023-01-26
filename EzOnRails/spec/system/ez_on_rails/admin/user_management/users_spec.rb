# frozen_string_literal: true

require 'rails_helper'

# Spec for testing the behavior of the broom closets unattached files capabilities.
# Testing if the admin is able to see and delete file blobs, which are not attached to any record.
RSpec.describe 'User management user view' do
  # users
  let(:john) { create(:john) }
  let(:andrew) { create(:andrew) }

  context 'when not logged in' do
    it 'can not update johns password' do
      visit "ez_on_rails/admin/user_management/users/#{john.id}/password_reset"

      expect(page).to have_current_path(new_user_session_path)
    end
  end

  context 'when logged in as andrew' do
    before do
      system_log_in andrew.email, 'andrewandrew'
    end

    it 'can not update johns password' do
      visit "ez_on_rails/admin/user_management/users/#{john.id}/password_reset"

      expect(page).to have_text t(:'ez_on_rails.access_denied')
      expect(page).to have_text t(:'ez_on_rails.access_denied_message')
    end
  end

  context 'when logged in as admin' do
    before do
      system_log_in User.super_admin.email, '1replace_me3_after3_install7'
    end

    it 'can update johns password' do
      visit "ez_on_rails/admin/user_management/users/#{john.id}/password_reset"

      fill_in 'user_password', with: 'banana'
      click_on t(:'ez_on_rails.save')

      expect(page).to have_text t(:reset_password_success)
    end
  end
end
