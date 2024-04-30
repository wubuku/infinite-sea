module infinite_sea_common::ship_util {

    use infinite_sea_common::item_id;
    use infinite_sea_common::item_id_quantity_pair;
    use infinite_sea_common::item_id_quantity_pair::ItemIdQuantityPair;
    use infinite_sea_common::vector_util;

    const DEFAULT_SHIP_HEALTH_POINTS: u32 = 20;

    const ENormalLogsNotFound: u64 = 1;
    const ECottonsNotFound: u64 = 2;
    const ECopperOresNotFound: u64 = 3;

    public fun calculate_ship_attributes(building_expences: &vector<ItemIdQuantityPair>): (u32, u32, u32, u32) {
        let copper_ore = vector_util::get_item_id_quantity_pair_or_else_abort(
            building_expences, item_id::copper_ore(), ECopperOresNotFound);
        let copper_ore_quantity = item_id_quantity_pair::quantity(&copper_ore);
        let normal_logs = vector_util::get_item_id_quantity_pair_or_else_abort(
            building_expences, item_id::normal_logs(), ENormalLogsNotFound);
        let normal_log_quantity = item_id_quantity_pair::quantity(&normal_logs);
        let cottons = vector_util::get_item_id_quantity_pair_or_else_abort(
            building_expences, item_id::cottons(), ECottonsNotFound);
        let cottons_quantity = item_id_quantity_pair::quantity(&cottons);

        let health_points: u32 = DEFAULT_SHIP_HEALTH_POINTS; //todo ???
        let attack = copper_ore_quantity;
        let protection = normal_log_quantity;
        let speed = cottons_quantity;
        (health_points, attack, protection, speed)
    }
}
