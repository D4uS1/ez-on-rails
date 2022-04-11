# frozen_string_literal: true

# Application helper of the EzOnRails engine.
module EzOnRails::ApplicationHelper
  # BEGIN: Webpacker integratiom from https://github.com/rails/webpacker/blob/master/docs/engines.md
  include ::Webpacker::Helper

  # Returns the current webpacker instance of the engine.
  def current_webpacker_instance
    EzOnRails.webpacker
  end
  # END: Webpacker integration
end
