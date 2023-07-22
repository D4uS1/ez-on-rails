# frozen_string_literal: true

# API Error class holding a http_status and message.
# Each catchable error in the api should inherit from this class and pass
# the message and http status to this super class.
# The ApiController has a method to catch ApiErrors and passes an default formatted error json
# back to the client.
class EzOnRails::Error < StandardError
  # Constructor takes the message and http status code and saves the values to
  # accessible instance variables.
  def initialize(message:, http_status:)
    super()

    @message = message
    @http_status = http_status
  end

  attr_accessor :message, :http_status
end
