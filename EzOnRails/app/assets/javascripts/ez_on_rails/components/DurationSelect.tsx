import React, {useEffect, useState} from 'react'

/**
 * Props for the DurationSelect component.
 */
interface DurationSelectProps {
    id: string,
    name: string,
    default_value?: string,
    max_years?: number,
    label_years?: string,
    label_months?: string,
    label_weeks?: string,
    label_days?: string,
    label_hours?: string,
    label_minutes?: string,
    label_seconds?: string
}

/**
 * Component to render a duration object, resulting in an iso8601 duration string.
 * The default_value in the props is the selected value.
 * The id and name in the props are used in the hidden input field having the resulting iso string.
 * The max_years value defines the maximum amount of years shown in the years selct box. The default value is 10.
 * The default values for the labels will be the english ones.
 *
 * @param value
 * @constructor
 */
export const DurationSelect = (props: DurationSelectProps) => {
    const [value, setValue] = useState<string | undefined>(props.default_value || 'P');
    const [years, setYears] = useState<number>(0);
    const [months, setMonths] = useState<number>(0);
    const [weeks, setWeeks] = useState<number>(0);
    const [days, setDays] = useState<number>(0);
    const [hours, setHours] = useState<number>(0);
    const [minutes, setMinutes] = useState<number>(0);
    const [seconds, setSeconds] = useState<number>(0);

    /**
     * Called if the default value changes.
     * Parses the default_value iso string and sets all states to the correct values.
     */
    useEffect(() => {
        if (!props.default_value) {
            return;
        }

        // Remove the initializing P
        const withoutP = props.default_value.replace("P", "");

        // split into date and time part
        const parts = withoutP.split('T');
        const datePart = parts[0]
        const timePart = parts.length > 1 ? parts[1] : "";

        // parse date values with regex
        const dateMatches = datePart.match(/((\d)+Y)?((\d+)M)?((\d)+W)?((\d)+D)?/)
        setYears(dateMatches[2] ? dateMatches[2] : 0)
        setMonths(dateMatches[4] ? dateMatches[4] : 0)
        setWeeks(dateMatches[6] ? dateMatches[6] : 0)
        setDays(dateMatches[8] ? dateMatches[8] : 0)

        // parse time values with regex
        const timeMatches = timePart.match(/((\d)+H)?((\d+)M)?((\d)+S)?/)
        setHours(timeMatches[2] ? timeMatches[2] : 0)
        setMinutes(timeMatches[4] ? timeMatches[4] : 0)
        setSeconds(timeMatches[6] ? timeMatches[6] : 0)
    }, [props.default_value]);

    /**
     * Called if some value in the states for the duration changes.
     * Calculates the iso string value depending on the current years, months, days, hours, minutes and seconds states.
     * Sets the new value into the value state.
     */
    useEffect(() => {
        let res = "P";
        if (years > 0)  res = `${res}${years}Y`;
        if (months > 0)  res = `${res}${months}M`;
        if (weeks > 0)  res = `${res}${weeks}W`;
        if (days > 0)  res = `${res}${days}D`;
        if (hours > 0 || minutes > 0 || seconds > 0) {
            res = `${res}T`;
            if (hours > 0)  res = `${res}${hours}H`;
            if (minutes > 0)  res = `${res}${minutes}M`;
            if (seconds > 0)  res = `${res}${seconds}S`;
        }

        setValue(res);
    }, [years, months, weeks, days, hours, minutes, seconds])

    /**
     * Called if the user changes the years selection.
     * Updates the state and recalculates the value.
     *
     * @param e
     */
    const onChangeYears = (e) => {
        setYears(parseInt(e.currentTarget.value, 10));
    }

    /**
     * Called if the user changes the months selection.
     * Updates the state and recalculates the value.
     *
     * @param e
     */
    const onChangeMonths = (e) => {
        setMonths(parseInt(e.currentTarget.value, 10));
    }

    /**
     * Called if the user changes the months selection.
     * Updates the state and recalculates the value.
     *
     * @param e
     */
    const onChangeWeeks = (e) => {
        setWeeks(parseInt(e.currentTarget.value, 10));
    }

    /**
     * Called if the user changes the days selection.
     * Updates the state and recalculates the value.
     *
     * @param e
     */
    const onChangeDays = (e) => {
        setDays(parseInt(e.currentTarget.value, 10));
    }

    /**
     * Called if the user changes the hours selection.
     * Updates the state and recalculates the value.
     *
     * @param e
     */
    const onChangeHours = (e) => {
        setHours(parseInt(e.currentTarget.value, 10));
    }

    /**
     * Called if the user changes the minutes selection.
     * Updates the state and recalculates the value.
     *
     * @param e
     */
    const onChangeMinutes = (e) => {
        setMinutes(parseInt(e.currentTarget.value, 10));
    }

    /**
     * Called if the user changes the seconds selection.
     * Updates the state and recalculates the value.
     *
     * @param e
     */
    const onChangeSeconds = (e) => {
        setSeconds(parseInt(e.currentTarget.value, 10));
    }

    const yearsArray = [];
    const lastYear = props.max_years || 10;
    for (let i = 0; i <= lastYear; i++) {
        yearsArray.push(i);
    }

    const monthsArray = []
    for (let i = 0; i <= 11; i++) {
        monthsArray.push(i)
    }

    const weeksArray = []
    for (let i = 0; i <= 4; i++) {
        weeksArray.push(i)
    }

    const daysArray = []
    for (let i = 0; i <= 6; i++) {
        daysArray.push(i)
    }

    const hoursArray = []
    for (let i = 0; i <= 11; i++) {
        hoursArray.push(i)
    }

    const minutesArray = []
    for (let i = 0; i <= 59; i++) {
        minutesArray.push(i)
    }

    const secondsArray = []
    for (let i = 0; i <= 59; i++) {
        secondsArray.push(i)
    }

    return <div className="duration-select-container">
        <input type="hidden" value={value} id={props.id} name={props.name} />

        { /* years */ }
        <div className="duration-select-selection-container">
            <label className="duration-select-selection-label">{props.label_years || 'Years'}:</label>
            <select className="duration-select-selection-select"
                    onChange={onChangeYears}
                    value={years}>
                {
                    yearsArray.map((val) => {
                        return <option key={ val } className="duration-select-selection-option" value={val}>{val}</option>
                    })
                }
            </select>
        </div>

        { /* months */ }
        <div className="duration-select-selection-container">
            <label className="duration-select-selection-label">{props.label_months || 'Months'}: </label>
            <select className="duration-select-selection-select"
                    onChange={onChangeMonths}
                    value={months}>
                {
                    monthsArray.map((val) => {
                        return <option key={ val } className="duration-select-selection-option" value={val}>{val}</option>
                    })
                }
            </select>
        </div>

        { /* weeks */ }
        <div className="duration-select-selection-container">
            <label className="duration-select-selection-label">{props.label_weeks || 'Weeks'}: </label>
            <select className="duration-select-selection-select"
                    onChange={onChangeWeeks}
                    value={weeks}>
                {
                    weeksArray.map((val) => {
                        return <option key={ val } className="duration-select-selection-option" value={val}>{val}</option>
                    })
                }
            </select>
        </div>

        { /* days */ }
        <div className="duration-select-selection-container">
            <label className="duration-select-selection-label">{props.label_days || 'Days'}: </label>
            <select className="duration-select-selection-select"
                    onChange={onChangeDays}
                    value={days}>
                {
                    daysArray.map((val) => {
                        return <option key={ val } className="duration-select-selection-option" value={val}>{val}</option>
                    })
                }
            </select>
        </div>

        { /* hours */ }
        <div className="duration-select-selection-container">
            <label className="duration-select-selection-label">{props.label_hours || 'Hours'}: </label>
            <select className="duration-select-selection-select"
                    onChange={onChangeHours}
                    value={hours}>
                {
                    hoursArray.map((val) => {
                        return <option key={ val } className="duration-select-selection-option" value={val}>{val}</option>
                    })
                }
            </select>
        </div>

        { /* minutes */ }
        <div className="duration-select-selection-container">
            <label className="duration-select-selection-label">{props.label_minutes || 'Minutes'}: </label>
            <select className="duration-select-selection-select"
                    onChange={onChangeMinutes}
                    value={minutes}>
                {
                    minutesArray.map((val) => {
                        return <option key={ val } className="duration-select-selection-option" value={val}>{val}</option>
                    })
                }
            </select>
        </div>

        { /* seconds */ }
        <div className="duration-select-selection-container">
            <label className="duration-select-selection-label">{props.label_seconds || 'Seconds'}: </label>
            <select className="duration-select-selection-select"
                    onChange={onChangeSeconds}
                    value={seconds}>
                {
                    secondsArray.map((val) => {
                        return <option key={ val } className="duration-select-selection-option" value={val}>{val}</option>
                    })
                }
            </select>
        </div>
    </div>
}

export default DurationSelect