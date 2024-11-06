# frozen_string_literal: true

# Helper module for UserOwnedRecord resource.
module UserOwnedRecordsHelper
  # Returns the render information for the UserOwnedRecord resource.
  def render_info_user_owned_record
    {
      test: {
        label: UserOwnedRecord.human_attribute_name(:test)
      }
    }
  end
end
