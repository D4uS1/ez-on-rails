# frozen_string_literal: true

require 'rails_helper'

# Spec for testing the index and submit action of the contact form.
RSpec.describe 'ContactFormController' do
  context 'when not logged in' do
    it 'can get index' do
      get contact_form_url

      expect(response).to have_http_status(:success)
    end

    it 'can submit' do
      post contact_form_submit_url, params: {
        contact_form: {
          name: 'John',
          email: 'john@no-snow.de',
          subject: 'i am not bad',
          message: 'trust me!',
          privacy_policy_accepted: 1
        }
      }

      expect(response).to redirect_to(contact_form_submit_success_path)
    end

    it 'can not submit without accepting privacy policy' do
      post contact_form_submit_url, params: {
        contact_form: {
          name: 'John',
          email: 'john@no-snow.de',
          subject: 'i am not bad',
          message: 'trust me!',
          privacy_policy_accepted: 0
        }
      }

      expect(response).to have_http_status(:unprocessable_content)
    end

    it 'sends emails to admin and user' do
      expect do
        post contact_form_submit_url, params: {
          contact_form: {
            name: 'John',
            email: 'john@no-snow.de',
            subject: 'i am not bad',
            message: 'trust me!',
            privacy_policy_accepted: 1
          }
        }
      end.to change { ActionMailer::Base.deliveries.count }.by(2)
    end
  end
end
