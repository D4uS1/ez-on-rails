# frozen_string_literal: true

# Controller class for a  resource.
class UserOwnedRecordsController < EzOnRails::ResourceController
  include UserOwnedRecordsHelper

  load_and_authorize_resource class: UserOwnedRecord

  before_action :breadcrumb_user_owned_record
  self.model_class = UserOwnedRecord

  protected

  # Sets the breadcrumb to the index action of the controllers resource.
  def breadcrumb_user_owned_record
    breadcrumb UserOwnedRecord.model_name.human(count: 2),
               controller: '/user_owned_records',
               action: 'index'
  end
end
