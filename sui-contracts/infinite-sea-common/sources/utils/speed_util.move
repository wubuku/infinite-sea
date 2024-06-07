module infinite_sea_common::speed_util {

    const STANDARD_SPEED_NUMERATOR: u32 = 5892;
    const STANDARD_SPEED_DENOMINATOR: u32 = 1000;

    const SPEED_NUMERATOR_DELTA: u32 = 589;

    /// Convert the speed property value to "coordinate units / second".
    public fun speed_property_to_coordinate_units_per_second(speed_property: u32): (u32, u32) {
        let numerator = STANDARD_SPEED_NUMERATOR;
        let denominator = STANDARD_SPEED_DENOMINATOR;
        if (speed_property < 5) {
            numerator = numerator - SPEED_NUMERATOR_DELTA * (5 - speed_property);
        } else {
            numerator = numerator + SPEED_NUMERATOR_DELTA * (speed_property - 5);
        };
        (numerator, denominator)
    }
}
