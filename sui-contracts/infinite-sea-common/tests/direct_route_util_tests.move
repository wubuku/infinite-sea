#[test_only]
module infinite_sea_common::direct_route_util_tests {

    use std::debug;

    use infinite_sea_common::coordinates;
    use infinite_sea_common::direct_route_util;

    #[test]
    public fun test_1() {
        // //let origin = coordinates::new(100, 100);
        // //let destination = coordinates::new(400, 500);
        // let origin = coordinates::new(400, 100);
        // let destination = coordinates::new(100, 500);
        // let speed_numerator = 5000;
        // let speed_denominator = 1000;
        // let elapsed_time = 50;
        // let result = direct_route_util::calculate_current_location(
        //     origin,
        //     destination,
        //     speed_numerator,
        //     speed_denominator,
        //     elapsed_time
        // );
        // debug::print(&coordinates::x(&result));
        // debug::print(&coordinates::y(&result));
    }
}