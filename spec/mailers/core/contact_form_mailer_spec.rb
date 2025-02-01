# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContactFormMailer do
  let(:mailer_params) do
    {
      name: 'Andrew Anderson',
      email: 'andrew@anderson.com',
      subject: 'This is awesome',
      message: 'Thank you for this awesome framework.'
    }
  end

  describe 'when sending contact_message' do
    it 'sends to super_admin' do
      mailer = described_class.with(mailer_params).contact_message

      expect(mailer.to).to eq([User.super_admin.email])
    end

    it 'sends with name, email, subject and message' do
      mailer = described_class.with(mailer_params).contact_message

      decoded_body = mailer.body.parts[0].decoded
      expect(decoded_body).to include('Andrew Anderson')
      expect(decoded_body).to include('andrew@anderson.com')
      expect(decoded_body).to include('This is awesome')
      expect(decoded_body).to include('Thank you for this awesome framework.')
    end
  end

  describe 'when sending contact_confirmation' do
    it 'sends to passed user email' do
      mailer = described_class.with(mailer_params).contact_confirmation

      expect(mailer.to).to eq(['andrew@anderson.com'])
    end

    it 'sends with name, email, subject, message and confirmation message' do
      mailer = described_class.with(mailer_params).contact_confirmation

      decoded_body = mailer.body.parts[0].decoded
      expect(decoded_body).to include('Andrew Anderson')
      expect(decoded_body).to include('andrew@anderson.com')
      expect(decoded_body).to include('This is awesome')
      expect(decoded_body).to include('Thank you for this awesome framework.')
      expect(decoded_body).to include(
        'We will answer as soon as possible ;).'
      )
    end
  end
end
