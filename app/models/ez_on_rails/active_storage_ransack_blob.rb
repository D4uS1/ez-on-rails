# frozen_string_literal: true

# This is a not really existing model that makes it possible to search in ActiveStorage::Blob models.
# The model includes the concern that adds the possible searchable attributes. It is needed by ransack.
# This is necessary to be able to search for blobs in the unattached files view.
class EzOnRails::ActiveStorageRansackBlob < ActiveStorage::Blob
  include EzOnRails::FullRansackSearchableConcern
end
