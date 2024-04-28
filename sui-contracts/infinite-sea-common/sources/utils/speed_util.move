module infinite_sea_common::speed_util {

    /// Convert the speed value to "coordinate units / second".
    public fun speed_to_coordinate_units_per_second(speed: u32): (u32, u32) {
        let numerator = speed;
        let denominator = 1;
        //todo
        (numerator, denominator)
    }
}
