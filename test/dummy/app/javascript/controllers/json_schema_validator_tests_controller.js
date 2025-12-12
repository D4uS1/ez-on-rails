import { Controller } from "@hotwired/stimulus"

/**
 * Stimulus controller for JsonSchemaValidatorTest actions.
 */
export default class extends Controller {
    static targets = ['testField']

    /**
     * Constructor.
     */
    connect() { }

    /**
     * Called if the test in the JsonSchemaValidatorTest form was changed.
     */
    onChangeTest(event) { }

}
