# frozen_string_literal: true

# Error class to describe an error caused by an request of a client that uses another api version.
class EzOnRails::InvalidVersionError < EzOnRails::Error
  # Constructor passes the message and http_status to the base constructor.
  def initialize
    super(message: 'invalid api version', http_status: :gone)
  end
end
