# frozen_string_literal: true

# Model class for a ContactForm Form having no Active Record.
class ContactForm
  include ActiveModel::Model

  validates :email, presence: true
  validates :message, presence: true
  validates :privacy_policy_accepted, acceptance: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  attr_accessor :name, :email, :subject, :message, :privacy_policy_accepted
end
