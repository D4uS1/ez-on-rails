# frozen_string_literal: true

# Error class to describe an unknown validation failed error.
class EzOnRails::ValidationFailedError < EzOnRails::ApiError
  # Constructor passes the message and http_status to the base constructor.
  def initialize(record)
    super(message: "validation failed: #{error_messages(record)}", http_status: :unprocessable_entity)
  end

  private

  # Returns all error messages of a given record in one string.
  def error_messages(record)
    record.errors.messages.map { |field_key, message| "#{field_key}: #{message}" }.join ','
  end
end
