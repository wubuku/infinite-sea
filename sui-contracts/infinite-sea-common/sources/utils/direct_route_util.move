module infinite_sea_common::direct_route_util {

    use sui::math;

    use infinite_sea_common::coordinates;
    use infinite_sea_common::coordinates::Coordinates;

    // Get distance between two points
    public fun get_distance(origin: Coordinates, destination: Coordinates): u64 {
        let o_x = coordinates::x(&origin);
        let o_y = coordinates::y(&origin);
        let d_x = coordinates::x(&destination);
        let d_y = coordinates::y(&destination);
        let x_diff = if (o_x > d_x) { o_x - d_x } else { d_x - o_x };
        let y_diff = if (o_y > d_y) { o_y - d_y } else { d_y - o_y };
        math::sqrt(((x_diff * x_diff + y_diff * y_diff) as u64))
    }

    public fun calculate_current_location(
        origin: Coordinates,
        destination: Coordinates,
        speed_numerator: u32,
        speed_denominator: u32,
        elapsed_time: u64,
    ): Coordinates {
        let o_x = coordinates::x(&origin);
        let o_y = coordinates::y(&origin);
        let d_x = coordinates::x(&destination);
        let d_y = coordinates::y(&destination);
        let x_diff_sign = o_x > d_x; //true for negative
        let y_diff_sign = o_y > d_y;
        let x_diff = if (x_diff_sign) { o_x - d_x } else { d_x - o_x };
        let y_diff = if (y_diff_sign) { o_y - d_y } else { d_y - o_y };
        let total_distance = math::sqrt(((x_diff * x_diff + y_diff * y_diff) as u64));

        let total_time = total_distance * (speed_denominator as u64) / (speed_numerator as u64);
        if (elapsed_time >= total_time) {
            return destination
        };
        // time_ratio = elapsed_time / total_time;
        let c_x = if (x_diff_sign) {
            (o_x as u64) - (x_diff as u64) * elapsed_time / total_time
        } else {
            (o_x as u64) + (x_diff as u64) * elapsed_time / total_time
        };
        let c_y = if (y_diff_sign) {
            (o_y as u64) - (y_diff as u64) * elapsed_time / total_time
        } else {
            (o_y as u64) + (y_diff as u64) * elapsed_time / total_time
        };
        coordinates::new((c_x as u32), (c_y as u32))
    }
}
