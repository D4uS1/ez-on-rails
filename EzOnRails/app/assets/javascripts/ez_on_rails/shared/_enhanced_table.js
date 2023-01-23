import $ from 'jquery'

/**
 * documentReady function to append it to turbolinks loader later.
 */
const onDocumentReady = () => {
  /**
   * Called if the checkbox for selecting all rows of an enhanced table is clicked.
   * Will check or uncheck (depending of the state of the checkbox itself) all selection
   * checkboxes of its table.
   */
  $('.enhanced-table-select-all').click(function () {
    const tableId = $(this).data('table-id');
    const checked = $(this).prop('checked');
    $("[name='enhanced_table_select_row[" + tableId + "]']").each(function () {
      $(this).prop('checked', checked);
    });
  });

  /**
   * Executes the action of some enhanced table defined by the given action data.
   * The actionData can contain a name of an oclick function which will be executed.
   * If no onclick action is defined, some target url is expected to be defined with
   * the url and method attribute. actionData also expects the tableId of the table.
   */
  const  enhancedTableAction = (actionData) => {
    // Catch selections
    const selections = [];
    $("[name='enhanced_table_select_row[" + actionData.tableId + "]']").each(function () {
      // needed because rails form helper adds some hidden field checkbox for some reason
      if ($(this).prop('type') === "hidden")  return;

      // get the row and put the id and data tags to selections
      const tr = $(this).closest('tr');
      if ($(this).prop('checked')) {
        selections.push({
          id: tr.prop('id'),
          data: tr.data()
        });
      }
    });

    // If this is a button to call some javascript function, call it
    if (actionData.onclick) {
      return $[actionData.onclick](selections);
    }

    // Otherwise call the ajax request given by url and method
    $.ajax(actionData.url, {
      type: actionData.method,
      data: {
        selections: JSON.stringify(selections)
      }
    });
  };

  /**
   * Called if some action button in an enhanced table is clicked.
   * If this button has a target url, this url will be called using ajax.
   * If some method is specified, this will be used as http method for targeting the url.
   * If some onclick listener is assigned, the onclick Method will be called.
   * In all cases the selected rows will be passed as parameter. If the url is called, the parameter will be
   * called selections. It contains a json array of all selected row ids.
   * If a onclick listener is called, the json array will be passed as function parameter.
   */
  $('button.enhanced-table-action').click(function () {
    //Catch the data of the action defined by the button
    const actionData = {
      onclick: $(this).data('onclick'),
      url: $(this).data('target'),
      method: $(this).data('method') || 'POST',
      tableId: $(this).data('table-id')
    };

    // Catch confirmation data
    const confirmData = $(this).data('confirm-message');

    // If some confirmation is requested, ask for the confirmation
    if (confirmData) {
      if (window.confirm(confirmData.message)) {
        enhancedTableAction(actionData);
      }
    } else {
      // if no confirmation is requested, just call the action
      enhancedTableAction(actionData);
    }
  });
};

// The turbolinks ready handler for page load.
$(document).on('turbo:load', onDocumentReady);