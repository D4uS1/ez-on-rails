# frozen_string_literal: true

# Error class to describe an unknown internal server error.
class EzOnRails::InternalServerError < EzOnRails::ApiError
  # Constructor passes the message and http_status to the base constructor.
  def initialize
    super(message: 'internal server error', http_status: :internal_server_error)
  end
end
