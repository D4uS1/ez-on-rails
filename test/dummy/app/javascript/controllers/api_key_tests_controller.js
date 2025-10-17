import { Controller } from "@hotwired/stimulus"

/**
 * Stimulus controller for ApiKeyTest actions.
 */
export default class extends Controller {
    static targets = ['testField']

    /**
     * Constructor.
     */
    connect() { }

    /**
     * Called if the test in the ApiKeyTest form was changed.
     */
    onChangeTest(event) { }

}
