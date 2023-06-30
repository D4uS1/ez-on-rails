import { Controller } from "@hotwired/stimulus"

/**
 * Stimulus controller for a association field to polymorphic associations.
 */
export default class extends Controller {
    static targets = ["typeTypeField", "recordIdField" ]

    /**
     * Constructor saves the data passed from the view to this instance to make it accessible in
     * the event handlers.
     */
    connect() {
        /*
         * Expects an object with the selectable types as keys, and the following values:
         * type_label: The label for the record type in the type selection field.
         * records: An array of objects, where each object has an id and label value. This is used for the record selection field.
         */
        this.recordsData = JSON.parse(this.data.get("recordsData"));

        // default value selection, if we edit some record that was already selected
        this.currentType = this.data.get("defaultValueType") || Object.keys(this.recordsData)[0];
        this.currentId = this.data.get("defaultValueId");

        this.nullable = this.data.get("nullable") === "true";

        // update the selectable records
        this.updateSelectableRecords();
    }


    /**
     * Called if the selected record type changes.
     * Changes the selectable items of the record field to the records of the selected type.
     *
     * @param e
     */
    onChangeRecordType(e) {
        this.currentType = e.target.value;

        // get default selection for new records
        if (this.nullable) {
            this.currentId = null;
        } else {
            // this will cause the select option that is added for the first record to be the selected one
            // this is needed because if the relation is not nullable, some record must be selected
            if (this.recordsData[this.currentType]["records"].length > 0) {
                this.currentId = this.recordsData[this.currentType]["records"][0]["id"];
            } else {
                this.currentId = null;
            }
        }

        // Change id field to show only selections of the new type
        this.updateSelectableRecords();
    }

    onChangeRecordId(e) {

    }

    /**
     * Changes the options in the field to select the record id.
     * Updates the field to show only the records of the currentType.
     */
    updateSelectableRecords() {
        // first remove all entries
        this.recordIdFieldTarget.innerHTML = '';

        // If no type was selected, the selection should be empty
        if (!this.currentType) return;

        // If the field is nullable, add the null value option
        if (this.nullable) {
            this.addRecordIdOption(null, " ");
        }

        // Add item for each record of selected type
        this.recordsData[this.currentType]["records"].forEach((recordData) => {
            this.addRecordIdOption(recordData["id"], recordData["label"])
        })
    }

    /**
     * Adds an option to the id selection field having the specified id and label.
     * If the id is the currentSelectedIt, the selected value will be set to the dom.
     *
     * @param id
     * @param label
     */
    addRecordIdOption(id, label) {
        const opt = document.createElement('option');
        opt.value = id === null ? "" : id;
        opt.selected = this.currentId === id;
        opt.innerHTML = label;
        opt.classList.add("polymorphic-association-field-select-option");

        this.recordIdFieldTarget.appendChild(opt);
    }
}
