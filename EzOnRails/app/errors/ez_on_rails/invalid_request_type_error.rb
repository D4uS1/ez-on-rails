# frozen_string_literal: true

# Error class to describe an unknown internal server error.
class EzOnRails::InvalidRequestTypeError < EzOnRails::ApiError
  # Constructor passes the message and http_status to the base constructor.
  def initialize
    super(message: 'invalid request type.', http_status: :not_acceptable)
  end
end
