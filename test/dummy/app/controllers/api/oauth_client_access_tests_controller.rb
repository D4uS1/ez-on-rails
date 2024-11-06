# frozen_string_literal: true

# Controller class for a OauthClientAccessTest resource.
class Api::OauthClientAccessTestsController < EzOnRails::Api::ResourceController
  include ::OauthClientAccessTestsHelper
  load_and_authorize_resource class: OauthClientAccessTest

  self.model_class = OauthClientAccessTest
end
