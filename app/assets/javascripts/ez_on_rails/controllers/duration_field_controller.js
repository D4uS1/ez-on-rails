import { Controller } from "@hotwired/stimulus"

/**
 * Stimulus controller for a duration field.
 */
export default class extends Controller {
    static targets = ["valueField", "yearsField", "monthsField", "weeksField", "daysField", "hoursField", "minutesField", "secondsField" ]

    /**
     * Constructor reads all value parts from the valueFields value and saves it into instance variables.
     * If the initialValue is not yet given, all defaults will result to 0.
     */
    connect() {
        const initialValue = this.valueFieldTarget.value;

        // no value yet given, set all to 0
        if (!initialValue) {
            this.years = 0;
            this.months = 0;
            this.weeks = 0;
            this.days = 0;
            this.hours = 0;
            this.minutes = 0;
            this.seconds = 0;

            return;
        }

        // Remove the initializing P
        const withoutP = initialValue.replace("P", "");

        // split into date and time part
        const parts = withoutP.split('T');
        const datePart = parts[0]
        const timePart = parts.length > 1 ? parts[1] : "";

        // parse date values with regex
        const dateMatches = datePart.match(/((\d)+Y)?((\d+)M)?((\d)+W)?((\d)+D)?/)
        this.years = dateMatches[2] ? dateMatches[2] : 0;
        this.yearsFieldTarget.value = this.years;
        this.months = dateMatches[4] ? dateMatches[4] : 0;
        this.monthsFieldTarget.value = this.months;
        this.weeks = dateMatches[6] ? dateMatches[6] : 0;
        this.weeksFieldTarget.value = this.weeks;
        this.days = dateMatches[8] ? dateMatches[8] : 0;
        this.daysFieldTarget.value = this.days;

        // parse time values with regex
        const timeMatches = timePart.match(/((\d)+H)?((\d+)M)?((\d)+S)?/)
        this.hours = timeMatches[2] ? timeMatches[2] : 0;
        this.hoursFieldTarget.value = this.hours;
        this.minutes = timeMatches[4] ? timeMatches[4] : 0;
        this.minutesFieldTarget.value = this.minutes;
        this.seconds = timeMatches[6] ? timeMatches[6] : 0;
        this.secondsFieldTarget.value = this.seconds;
    }


    /**
     * Called if the user changes the years selection.
     * Updates the state and recalculates the value.
     *
     * @param e
     */
    onChangeYears(e) {
        this.years = parseInt(e.target.value, 10);

        this.calcAndSetValue();
    }

    /**
     * Called if the user changes the months selection.
     * Updates and recalculates the duration value.
     *
     * @param e
     */
    onChangeMonths(e) {
        this.months = parseInt(e.target.value, 10);

        this.calcAndSetValue();
    }

    /**
     * Called if the user changes the months selection.
     * Updates and recalculates the duration value.
     *
     * @param e
     */
    onChangeWeeks(e) {
        this.weeks = parseInt(e.target.value, 10);

        this.calcAndSetValue();
    }

    /**
     * Called if the user changes the days selection.
     * Updates and recalculates the duration value.
     *
     * @param e
     */
    onChangeDays(e) {
        this.days = parseInt(e.target.value, 10);

        this.calcAndSetValue();
    }

    /**
     * Called if the user changes the hours selection.
     * Updates and recalculates the duration value.
     *
     * @param e
     */
    onChangeHours(e) {
        this.hours = parseInt(e.target.value, 10);

        this.calcAndSetValue();
    }

    /**
     * Called if the user changes the minutes selection.
     * Updates and recalculates the duration value.
     *
     * @param e
     */
    onChangeMinutes(e) {
        this.minutes = parseInt(e.target.value, 10);

        this.calcAndSetValue();
    }

    /**
     * Called if the user changes the seconds selection.
     * Updates and recalculates the duration value.
     *
     * @param e
     */
    onChangeSeconds(e) {
        this.seconds = parseInt(e.target.value, 10);

        this.calcAndSetValue();
    }


    /**
     * Calculates the iso8601 value by the instance variable values and writes it to the valueFieldTarget.
     */
    calcAndSetValue() {
        let res = "P";
        if (this.years > 0)  res = `${res}${this.years}Y`;
        if (this.months > 0)  res = `${res}${this.months}M`;
        if (this.weeks > 0)  res = `${res}${this.weeks}W`;
        if (this.days > 0)  res = `${res}${this.days}D`;
        if (this.hours > 0 || this.minutes > 0 || this.seconds > 0) {
            res = `${res}T`;
            if (this.hours > 0)  res = `${res}${this.hours}H`;
            if (this.minutes > 0)  res = `${res}${this.minutes}M`;
            if (this.seconds > 0)  res = `${res}${this.seconds}S`;
        }

        this.valueFieldTarget.value = res;
    }

}
