# frozen_string_literal: true

# Controller class for a  resource.
class AssocTestsController < EzOnRails::ResourceController
  include AssocTestsHelper

  load_and_authorize_resource class: AssocTest

  before_action :breadcrumb_assoc_test
  self.model_class = AssocTest

  protected

  # Sets the breadcrumb to the index action of the controllers resource.
  def breadcrumb_assoc_test
    breadcrumb AssocTest.model_name.human(count: 2),
               controller: '/assoc_tests',
               action: 'index'
  end
end
