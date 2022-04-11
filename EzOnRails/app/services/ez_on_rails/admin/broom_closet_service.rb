# frozen_string_literal: true

# Service for the brooms for cleaning up the application.
# Contains e.g. methods for finding all resources that are user owned,
# but does not reference to any user.
class EzOnRails::Admin::BroomClosetService
  # The amount of minuits for files, from then on they are treated as unattached files
  UNATTACHED_FILES_MIN_AGE_MINUTES = 60

  # Returns the active models of the ownership infos,
  # which does not reference to any user.
  def nil_owners
    result = []

    EzOnRails::OwnershipInfo.all_classes.each do |model_class|
      result += model_class.where(owner: nil)
    end

    result
  end

  # Returns the blob infos of files which are not assigned to any
  # database record.
  def unattached_files
    ActiveStorage::Blob.all.unattached
                       .where('active_storage_blobs.created_at <= :time',
                              time: Time.zone.now - UNATTACHED_FILES_MIN_AGE_MINUTES.minutes)
                       .order(created_at: :asc)
  end

  # Destroys the nil owned resources.
  # The resources_info is expected to be an array of hashes.
  # Eeach hash contains a :type and an :id field.
  # The type is the full name of the resource to delete. The id is the active record id
  # of the object to delete.
  # Returns the number of successfully destroyed resources.
  def destroy_nil_owners(resources_info)
    destroyed = 0

    filter_by_resource_info(nil_owners, resources_info).each do |resource|
      destroyed += 1 if resource.destroy
    end

    destroyed
  end

  # Destroys the unattached files given by its blob ids.
  # The blobs will only be destroyed if they are unattached blobs.
  # Returns the number of successfully destroyed files.
  def destroy_unattached_files(blob_ids)
    purged = 0
    unattached = unattached_files

    ActiveStorage::Blob.where(id: blob_ids).each do |blob|
      purged += 1 if unattached.any? { |unattached_blob| unattached_blob.id == blob.id } && blob.purge
    end

    purged
  end

  private

  # Filters the given resource objects by the given resource_info array.
  # Resource info is expected to be an array of hashes, having the keys :type and :id.
  # :type defines the active record type and :id defines the id of the active record.
  def filter_by_resource_info(resources, resources_info)
    resources.select do |resource|
      resources_info.any? do |resource_info|
        resource.is_a?(Hash.const_get(resource_info[:type])) && resource.id == resource_info[:id]
      end
    end
  end
end
