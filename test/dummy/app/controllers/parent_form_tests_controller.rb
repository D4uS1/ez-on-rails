# frozen_string_literal: true

# Controller class for a  resource.
class ParentFormTestsController < EzOnRails::ResourceController
  include ParentFormTestsHelper
  include NestedFormTestsHelper

  load_and_authorize_resource class: ParentFormTest

  before_action :breadcrumb_parent_form_test
  self.model_class = ParentFormTest

  protected

  # Sets the breadcrumb to the index action of the controllers resource.
  def breadcrumb_parent_form_test
    breadcrumb ParentFormTest.model_name.human(count: 2),
               controller: '/parent_form_tests',
               action: 'index'
  end
end
