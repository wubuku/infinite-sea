module infinite_sea_common::direct_route_util {

    use sui::math;

    use infinite_sea_common::coordinates;
    use infinite_sea_common::coordinates::Coordinates;
    #[test_only]
    use std::debug;

    public fun get_distance(origin: Coordinates, destination: Coordinates): u64 {
        let o_x = coordinates::x(&origin);
        let o_y = coordinates::y(&origin);
        let d_x = coordinates::x(&destination);
        let d_y = coordinates::y(&destination);
        let x_diff = (if (o_x > d_x) { o_x - d_x } else { d_x - o_x } as u64);
        let y_diff = (if (o_y > d_y) { o_y - d_y } else { d_y - o_y } as u64);
        math::sqrt(x_diff * x_diff + y_diff * y_diff)
    }

    #[test]
    public fun test_get_distince() {
        let original = coordinates::new(2147496697, 2147487097);
        let destination = coordinates::new(214741783, 214741570);
        // let original = coordinates::new(2147496697, 2147487097);
        // let destination = coordinates::new(2147506697, 2147497097);
        let distance = get_distance(original, destination);
        debug::print(&distance);
    }
}
