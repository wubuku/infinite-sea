#[test_only]
module infinite_sea_common::speed_util_tests {

    use std::debug;

    use infinite_sea_common::coordinates;
    use infinite_sea_common::speed_util;

    #[test]
    public fun test_1() {
        let originCoordinatesX = 2147483647;
        let originCoordinatesY = 2147483647;
        let targetCoordinatesX = 2147483807;//originCoordinatesX + 10;
        let targetCoordinatesY = 2147485457;
        let t = speed_util::calculate_total_time(
            coordinates::new(originCoordinatesX, originCoordinatesY),
            coordinates::new(targetCoordinatesX, targetCoordinatesY),
            5
        );
        debug::print(&t);
    }
}