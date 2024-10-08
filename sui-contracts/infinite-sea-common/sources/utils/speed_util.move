module infinite_sea_common::speed_util {

    use std::debug;
    use infinite_sea_common::direct_route_util;
    use infinite_sea_common::coordinates::Coordinates;
    #[test_only]
    use infinite_sea_common::coordinates;

    const STANDARD_SPEED_NUMERATOR: u32 = 23568;
    const STANDARD_SPEED_DENOMINATOR: u32 = 1000;

    const SPEED_NUMERATOR_DELTA: u32 = 2356;

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

    public fun calculate_total_time(origin: Coordinates, destination: Coordinates, speed_property: u32): u64 {
        let distance = direct_route_util::get_distance(origin, destination);
        debug::print(&distance);
        let (speed_numerator, speed_denominator) = speed_property_to_coordinate_units_per_second(
            speed_property
        );
        debug::print(&speed_numerator);
        debug::print(&speed_denominator);
        let total_time = distance * (speed_denominator as u64) / (speed_numerator as u64);
        total_time
    }

    #[test]
    public fun test_calculate_total_time()
    {
        let original = coordinates::new(2147529765,2147506919);
        let destination = coordinates::new(2147533552, 2147504949);
        let speed = 9;
        let total_time = calculate_total_time(original, destination, speed);
        debug::print(&total_time);
    }
}
