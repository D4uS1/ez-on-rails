# frozen_string_literal: true

# Helper module for NotUserOwnedRecord resource.
module NotUserOwnedRecordsHelper
  # Returns the render information for the NotUserOwnedRecord resource.
  def render_info_not_user_owned_record
    {
      test: {
        label: NotUserOwnedRecord.human_attribute_name(:test)
      }
    }
  end
end
