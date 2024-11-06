# frozen_string_literal: true

# Controller class for a  resource.
class NestedFormTestsController < EzOnRails::ResourceController
  include NestedFormTestsHelper

  load_and_authorize_resource class: NestedFormTest

  before_action :breadcrumb_nested_form_test
  self.model_class = NestedFormTest

  protected

  # Sets the breadcrumb to the index action of the controllers resource.
  def breadcrumb_nested_form_test
    breadcrumb NestedFormTest.model_name.human(count: 2),
               controller: '/nested_form_tests',
               action: 'index'
  end
end
