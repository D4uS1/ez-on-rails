# frozen_string_literal: true

# Controller class for a ContactForm form which has no ActiveRecord.
class ContactFormController < EzOnRails::ApplicationController
  include EzOnRails::LayoutToggleHelper
  include ContactFormHelper

  before_action :set_breadcrumb_contact_form
  before_action :redirect_on_disable

  # Action for showing the form.
  def index
    @subtitle = t(:contact_form_subtitle)
    @contact_form = ContactForm.new
  end

  # Action for submitting the form.
  def submit
    @contact_form = ContactForm.new(contact_form_params)

    if @contact_form.valid?
      # extract mail params
      mail_params = {
        name: @contact_form.name,
        email: @contact_form.email,
        subject: @contact_form.subject,
        message: @contact_form.message
      }

      # send to the admin
      ContactFormMailer.with(mail_params).contact_message.deliver_now

      # send confirmation to the user
      ContactFormMailer.with(mail_params).contact_confirmation.deliver_now

      # Do Some Stuff here
      flash[:success] = t(:message_sent_success)
      render :submit
    else
      flash[:danger] = t(:message_sent_fail)
      render :index
    end
  end

  protected

  # See description of set_title in ApplicationController.
  def set_title
    @title = ContactForm.model_name.human
  end

  # Sets the breadcrumb of the contact form.
  def set_breadcrumb_contact_form
    breadcrumb ContactForm.model_name.human,
               controller: 'contact_form',
               action: 'index'
  end

  # Called in before_action to redirect to root_path if the contact form
  # is disabled via layout_toggle_helper.
  def redirect_on_disable
    redirect_to root_path unless show_contact_form?
  end

  private

  # Only allow a trusted parameter "white list" through.
  def contact_form_params
    params.require(:contact_form).permit(render_info_contact_form.keys)
  end
end
