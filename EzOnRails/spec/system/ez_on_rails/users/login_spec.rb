# frozen_string_literal: true

require 'rails_helper'

# Spec for testing the login behavior.
# Testing that some user can not login without password or wrong password.
RSpec.describe 'User login' do
  let(:john) { create(:john) }

  context 'when user logs in' do
    it 'without pw should not login' do
      visit '/users/sign_in'

      fill_in 'user_email', with: john.email
      click_on 'button'

      expect(page).not_to have_text john.username
    end

    it 'with wrong should not login' do
      visit '/users/sign_in'

      fill_in 'user_email', with: john.email
      fill_in 'user_password', with: 'totallyWrongPassword'
      click_on 'button'

      expect(page).not_to have_text john.username
    end

    it 'with correct pw should login' do
      visit '/users/sign_in'

      fill_in 'user_email', with: john.email
      fill_in 'user_password', with: john.password
      click_on 'button'

      expect(page).to have_text john.username
    end
  end
end
