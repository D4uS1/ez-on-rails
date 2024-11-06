# frozen_string_literal: true

# Error class to describe the access to some resource is forbidden.
class EzOnRails::UnauthorizedError < EzOnRails::Error
  # Constructor passes the message and http_status to the base constructor.
  def initialize
    super(message: 'Access denied. Cou need to sign in first.', http_status: :unauthorized)
  end
end
