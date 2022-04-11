# frozen_string_literal: true

require 'rails_helper'

# Spec for testing the index action of the imprint.
RSpec.describe 'ez_on_rails/imprint', type: :request do
  context 'when not logged in' do
    it 'can get index' do
      get imprint_url

      expect(response).to have_http_status(:success)
    end
  end
end
