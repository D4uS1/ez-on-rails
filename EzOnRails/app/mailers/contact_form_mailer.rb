# frozen_string_literal: true

# Mailer class for the contact form.
class ContactFormMailer < EzOnRails::ApplicationMailer
  default from: "contact@#{Rails.application.class.module_parent.to_s.camelize}.com"

  # Action for sending the user message to the administrator.
  def contact_message
    @name = params[:name]
    @email = params[:email]
    @subject = params[:subject]
    @message = params[:message]
    mail(to: User.super_admin.email.to_s,
         subject: t(:message_received_subject))
  end

  # Action for the confirmation mail to the user.
  def contact_confirmation
    @name = params[:name]
    @email = params[:email]
    @subject = params[:subject]
    @message = params[:message]
    mail(to: @email,
         subject: t(:message_received_subject))
  end
end
