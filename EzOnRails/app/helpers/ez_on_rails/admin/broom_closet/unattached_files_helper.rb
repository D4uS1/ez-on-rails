# frozen_string_literal: true

# Helper module for the broom closet views, containing the render
# information.
module EzOnRails::Admin::BroomCloset::UnattachedFilesHelper
  # Returns the render information of the view of unattached files.
  def render_info_unattached_files
    {
      id: {
        label: t(:'ez_on_rails.id'),
        search_method: :eq,
        no_sort: true
      },
      filename: {
        label: t(:'ez_on_rails.filename'),
        no_sort: true
      },
      content_type: {
        label: t(:'ez_on_rails.content_type'),
        no_sort: true
      },
      byte_size: {
        label: t(:'ez_on_rails.byte_size'),
        no_sort: true
      },
      created_at: {
        label: t(:'ez_on_rails.created_at'),
        no_sort: true
      }
    }
  end
end
