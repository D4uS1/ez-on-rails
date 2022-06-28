# documentReady Funktion to append it to tiurbolinks loader later
onDocumentReady = ->
  # Called if the checkbox for selecting all rows of an enhanced table is clicked.
  # Will check or uncheck (depending of the state of the checkbox itself) all selection
  # checkboxes of its table.
  $('.enhanced-table-select-all').click (e) ->
    tableId = $(this).data 'table-id'
    checked = $(this).prop 'checked'
    $("[name='enhanced_table_select_row[#{tableId}]']").each (checkbox) ->
      $(this).prop 'checked', checked

  # Called if some action button in an enhanced table is clicked.
  # If this button has a target url, this url will be called using ajax.
  # If some method is specified, this will be used as http method for targeting the url.
  # If some onclick listener is assigned, the onclick Method will be called.
  # In all cases the selected rows will be passed as parameter. If the url is called, the parameter will be
  # called selections. It contains a json array of all selected row ids.
  # If a onclick listener is called, the json array will be passed as function parameter.
  $('button.enhanced-table-action').click (e) ->
    # Catch the data of the action defined by the button
    actionData = {
      onclick: $(this).data('onclick'),
      url: $(this).data('target'),
      method: $(this).data('method') || 'POST',
      tableId: $(this).data('table-id')
    }

    # Cacth confirmation data
    confirmData = $(this).data('confirm-message')

    # If some confirmation is requested, ask for the confirmation
    if confirmData
      # ask for confirmation
      return dataConfirmModal.confirm({
        title: confirmData.title,
        text: confirmData.confirm,
        commit: confirmData.commit,
        cancel: confirmData.cancel,
        zIindex: 10099,
        onConfirm: () -> enhancedTableAction(actionData)
      })

    # if no confirmation is requested, just call the action
    return enhancedTableAction(actionData)


  # Executes the action of some enhanced table defined by the given action data.
  # The actionData can contain a name of an oclick function which will be executed.
  # If no onclick action is defined, some target url is expected to be defined with
  # the url and method attribute. actionData also expects the tableId of the table.
  enhancedTableAction = (actionData) ->
    # Catch selections
    selections = []
    $("[name='enhanced_table_select_row[#{actionData.tableId}]']").each (checkbox) ->
      # needed because rails form helper adds some hidden field checkbox for some reason
      return if $(this).prop('type') == "hidden"

      # get the row and put the id and data tags to selections
      tr = $(this).closest('tr')
      if $(this).prop 'checked'
        selections.push({
          id: tr.prop('id'),
          data: tr.data()
        })

    # If this is a button to call some javascript function, call it
    return $[actionData.onclick](selections) if actionData.onclick

    # Otherwise call the ajax request given by url and method
    $.ajax actionData.url,
      type: actionData.method,
      data: {
        selections: JSON.stringify(selections)
      }

# The turbolinks ready handler for page load.
$(document).on 'turbolinks:load', onDocumentReady