# frozen_string_literal: true

# Error class to describe an error casued some not existing resource.
class EzOnRails::ResourceNotFoundError < EzOnRails::ApiError
  # Constructors passes the given message to the base class, including http status code 412.
  def initialize(message:)
    super(message: message, http_status: :not_found)
  end
end
