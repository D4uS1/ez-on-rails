# frozen_string_literal: true

# Error class to describe the access to some resource is forbidden.
class EzOnRails::ForbiddenError < EzOnRails::Error
  # Constructor passes the message and http_status to the base constructor.
  def initialize
    super(message: 'Forbidden.', http_status: :forbidden)
  end
end
