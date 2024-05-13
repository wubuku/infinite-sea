module infinite_sea_common::ship_util {

    use std::option;
    use std::option::Option;
    use std::vector;

    use sui::object::ID;

    use infinite_sea_common::item_id;
    use infinite_sea_common::item_id_quantity_pair;
    use infinite_sea_common::item_id_quantity_pair::ItemIdQuantityPair;
    use infinite_sea_common::sorted_vector_util;

    const ENormalLogsNotFound: u64 = 1;
    const ECottonsNotFound: u64 = 2;
    const ECopperOresNotFound: u64 = 3;

    const DEFAULT_SHIP_HEALTH_POINTS: u32 = 20;
    const NORMAL_SHIP_MAX_ATTACK: u32 = 5;
    const NORMAL_SHIP_MAX_PROTECTION: u32 = 5;
    const NORMAL_SHIP_MAX_SPEED: u32 = 5;

    public fun calculate_ship_attributes(building_expenses: &vector<ItemIdQuantityPair>): (u32, u32, u32, u32) {
        let copper_ore = sorted_vector_util::get_item_id_quantity_pair_or_else_abort(
            building_expenses, item_id::copper_ore(), ECopperOresNotFound);
        let copper_ore_quantity = item_id_quantity_pair::quantity(&copper_ore);
        let normal_logs = sorted_vector_util::get_item_id_quantity_pair_or_else_abort(
            building_expenses, item_id::normal_logs(), ENormalLogsNotFound);
        let normal_log_quantity = item_id_quantity_pair::quantity(&normal_logs);
        let cottons = sorted_vector_util::get_item_id_quantity_pair_or_else_abort(
            building_expenses, item_id::cottons(), ECottonsNotFound);
        let cottons_quantity = item_id_quantity_pair::quantity(&cottons);

        let health_points: u32 = DEFAULT_SHIP_HEALTH_POINTS; //todo Is this value ok?
        let attack = copper_ore_quantity; //todo Is this value ok?
        let protection = normal_log_quantity;
        let speed = cottons_quantity;
        (
            health_points,
            if (attack > NORMAL_SHIP_MAX_ATTACK) { NORMAL_SHIP_MAX_ATTACK } else { attack },
            if (protection > NORMAL_SHIP_MAX_PROTECTION) { NORMAL_SHIP_MAX_PROTECTION } else { protection },
            if (speed > NORMAL_SHIP_MAX_SPEED) { NORMAL_SHIP_MAX_SPEED } else { speed }
        )
    }

    /// Calculate the experience that can be gained by the building_expenses of the defeated environment ship.
    public fun calculate_environment_ship_experience(building_expenses: &vector<ItemIdQuantityPair>): u32 {
        let i = 0;
        let sum = 0;
        let l = vector::length(building_expenses);
        while (i < l) {
            let item = vector::borrow(building_expenses, i);
            //let item_id = item_id_quantity_pair::item_id(item); // ignore item_id
            let quantity = item_id_quantity_pair::quantity(item);
            sum = sum + quantity;
            i = i + 1;
        };
        if (sum >= 16) {
            6
        } else if (sum >= 12) {
            3
        } else if (sum >= 8) {
            2
        } else {
            1
        }
    }

    public fun remove_ship_id(ship_ids: &mut vector<ID>, ship_id: ID) {
        let i = 0;
        let l = vector::length(ship_ids);
        while (i < l) {
            if (*vector::borrow(ship_ids, i) == ship_id) {
                vector::remove(ship_ids, i);
                break
            };
            i = i + 1;
        }
    }

    public fun find_ship_id(ship_ids: &vector<ID>, ship_id: ID): Option<u64> {
        let i = 0;
        let l = vector::length(ship_ids);
        while (i < l) {
            if (*vector::borrow(ship_ids, i) == ship_id) {
                return option::some(i)
            };
            i = i + 1;
        };
        option::none()
    }
}
