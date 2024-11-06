# frozen_string_literal: true

# Contains helper methods for testing jwt authentication related methods.
module EzAuthTestHelper
  # Creates a new authentication token for the specified user and returns the
  # needed header information for the next request.
  def authorization_header_info(user)
    headers_raw = user.create_new_auth_token

    {
      client: headers_raw['client'],
      token: headers_raw['access-token'],
      expiry: headers_raw['expiry'],
      token_type: headers_raw['token-type'],
      uid: headers_raw['uid']
    }
  end
end
