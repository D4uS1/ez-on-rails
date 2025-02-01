# frozen_string_literal: true

# Controller class for a  resource.
class NotUserOwnedRecordsController < EzOnRails::ResourceController
  include NotUserOwnedRecordsHelper

  load_and_authorize_resource class: NotUserOwnedRecord

  before_action :breadcrumb_not_user_owned_record
  self.model_class = NotUserOwnedRecord

  protected

  # Sets the breadcrumb to the index action of the controllers resource.
  def breadcrumb_not_user_owned_record
    breadcrumb NotUserOwnedRecord.model_name.human(count: 2),
               controller: '/not_user_owned_records',
               action: 'index'
  end
end
