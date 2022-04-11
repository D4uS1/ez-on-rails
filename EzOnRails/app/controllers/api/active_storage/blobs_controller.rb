# frozen_string_literal: true

# Controller for additional actions of active storage uploads
# which are not provided by the default active storage controller and are secured by the access system.
# The code was deducted from:
# https://github.com/rails/rails/blob/main/activestorage/app/controllers/active_storage/direct_uploads_controller.rb.
class Api::ActiveStorage::BlobsController < EzOnRails::Api::BaseController
  include ActiveStorage::SetCurrent
  include ActiveStorage::BlobsControllerConcern
end
