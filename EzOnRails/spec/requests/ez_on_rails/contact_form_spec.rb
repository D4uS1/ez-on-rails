# frozen_string_literal: true

require 'rails_helper'

# Spec for testing the index and submit action of the contact form.
RSpec.describe 'ContactFormController' do
  context 'when not logged in' do
    it 'can get index' do
      get contact_form_url

      expect(response).to have_http_status(:success)
    end

    it 'can get submit' do
      post contact_form_submit_url, params: {
        contact_form: {
          name: 'John',
          email: 'john@no-snow.de',
          subject: 'i am not bad',
          message: 'trust me!'
        }
      }

      expect(response).to have_http_status(:success)
    end
  end
end
