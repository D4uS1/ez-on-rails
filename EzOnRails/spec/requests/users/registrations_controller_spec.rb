# frozen_string_literal: true

require 'rails_helper'

# Spec for testing some user management behavior.
# Contains tests checking wether a non logged in user (called anonymus here) can not edit or destroy an user
# (called andrew here).
# Contains tests wether some logged in user (called john here) cannot edit or destroy another user (called andrew here)
# Also tests whether some user is able to update or detsroy itself.
RSpec.describe 'Users::RegistrationsController' do
  # users
  let(:john) { create(:john) }
  let(:andrew) { create(:andrew) }

  context 'when not logged in' do
    it 'can not edit andrew' do
      get edit_user_registration_url, params: { id: andrew.id }

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not update andrew' do
      patch user_registration_url, params: { id: andrew.id }

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'can not destroy andrew' do
      delete user_registration_url, params: { id: andrew.id }

      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'when logged in as john' do
    before do
      sign_in john
    end

    # Test if some user could edit itself
    it 'can edit itself' do
      get edit_user_registration_url, params: { id: john.id }

      expect(response).to have_http_status(:success)
    end

    it 'can update itself but email needs confirmation' do
      old_email = john.email

      patch user_registration_url, params: {
        id: john.id,
        user: {
          username: john.username,
          email: 'updated@email.de',
          current_password: 'johnjohn'
        }
      }

      # Check wether the object has updated
      updated_object = User.find john.id
      expect(updated_object.email).to eql(old_email)
      expect(updated_object.unconfirmed_email).to eql('updated@email.de')
      expect(updated_object.username).to eql(john.username)
    end

    it 'can destroy itself' do
      delete user_registration_url, params: {
        id: john.id,
        user: {
          current_password: john.password
        }
      }

      expect(User.find_by(id: john.id)).to be_nil
    end
  end
end
