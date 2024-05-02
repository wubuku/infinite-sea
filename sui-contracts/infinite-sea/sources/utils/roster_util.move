module infinite_sea::roster_util {
    use std::option;
    use std::option::Option;
    use std::vector;

    use sui::object::ID;
    use sui::object_table;

    use infinite_sea::roster::{Self, Roster};
    use infinite_sea::ship;

    public fun add_ship_id(ship_ids: &mut vector<ID>, ship_id: ID, position: Option<u64>) {
        if (option::is_none(&position)) {
            vector::push_back(ship_ids, ship_id);
        } else {
            let idx = option::extract(&mut position);
            if (idx >= vector::length(ship_ids)) {
                vector::push_back(ship_ids, ship_id);
            } else {
                vector::insert(ship_ids, ship_id, idx);
            }
        };
    }

    public fun calculate_roster_speed(roster: &Roster): u32 {
        let ship_ids = roster::borrow_ship_ids(roster);
        let ships = roster::borrow_ships(roster);
        let speed = 0;
        let i = 0;
        let l = vector::length(ship_ids);
        while (i < l) {
            let ship_id = *vector::borrow(ship_ids, i);
            let ship = object_table::borrow(ships, ship_id);
            speed = speed + ship::speed(ship);
            i = i + 1;
        };
        speed / (l as u32)
    }

    public fun is_destroyed(roster: &Roster): bool {
        let ship_ids = roster::borrow_ship_ids(roster);
        let ships = roster::borrow_ships(roster);
        let i = 0;
        let l = vector::length(ship_ids);
        while (i < l) {
            let ship_id = *vector::borrow(ship_ids, i);
            let ship = object_table::borrow(ships, ship_id);
            if (ship::health_points(ship) > 0) {
                return false
            };
            i = i + 1;
        };
        true
    }
}
