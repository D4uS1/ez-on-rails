# frozen_string_literal: true

# Controller for additional actions of active storage uploads
# which are not provided by the default active storage controller.
class EzOnRails::ActiveStorage::BlobsController < EzOnRails::ApplicationController
  include ActiveStorage::SetCurrent
  include ActiveStorage::BlobsControllerConcern
end
