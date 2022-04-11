# frozen_string_literal: true

require 'rails_helper'

# Spec for testing the index action of the privacy policy controller.
RSpec.describe 'ez_on_rails/privacy_policy', type: :request do
  context 'when not logged in' do
    it 'can get index' do
      get privacy_policy_url

      expect(response).to have_http_status(:success)
    end
  end
end
