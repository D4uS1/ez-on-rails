# frozen_string_literal: true

# Helper module to interact with ez_on_rails views ajax actions.
# Is expected to be included in an ResourceController.
module EzOnRails::EzAjaxHelper
  # Returns the selections of an enhanced_table partial included in the given request params.
  # The result will be an array, containing hashes with the following key value pairs:
  # id: The id of the selected row
  # data: hash of key value pairs of data attributes of the selected row
  def enhanced_table_selections(params)
    return ActiveSupport::JSON.decode(params[:selections]).map(&:deep_symbolize_keys) if params[:selections]

    []
  end

  # Calls the selections_action block and passes the selected_ids and selected_data.
  # The selected_ids is an array of ids the user selected for the action.
  # The selected_data is an hash, where the hash keys are the ids of the selection and the hash values are
  # the data from the data attributes of the row, passed from the javascript.
  # After the selections_action execution finishes, the user will be redirected to the redirect_target.
  # The default target is the index action.
  def enhanced_table_selections_action(redirect_target: { action: :index }, &selections_action)
    # calculate data for passing the block
    table_selections = enhanced_table_selections(params)
    selected_ids = table_selections.map { |selection| selection[:data][:id] }
    selected_data = {}.tap { |obj| table_selections.each { |selection| obj[selection[:data][:id]] = selection[:data] } }

    # call the block
    selections_action.call selected_ids, selected_data

    # redirect after successfull operation
    render js: "window.location = '#{search_url_for(redirect_target, search_params)}'"
  end
end
