# frozen_string_literal: true

require 'ez_on_rails/engine'

# EzOnRails module, see README for details.
module EzOnRails
  # BEGIN: Webpacker integratiom from https://github.com/rails/webpacker/blob/master/docs/engines.md
  ROOT_PATH = Pathname.new(File.join(__dir__, '..'))

  class << self
    # Returns the webpacker instance for the engine to provide assets of the engine to the mounting
    # host application.
    def webpacker
      @webpacker ||= ::Webpacker::Instance.new(
        root_path: ROOT_PATH,
        config_path: ROOT_PATH.join('config/webpacker.yml')
      )
    end
  end
  # END: Webpacker integration
end
