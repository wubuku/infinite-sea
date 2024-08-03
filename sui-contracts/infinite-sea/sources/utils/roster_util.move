module infinite_sea::roster_util {
    use std::option;
    use std::option::Option;
    use std::vector;

    use sui::clock;
    use sui::clock::Clock;
    use sui::object::ID;
    use sui::object_table;
    use infinite_sea_common::coordinates;
    use infinite_sea_common::coordinates::Coordinates;
    use infinite_sea_common::direct_route_util;
    use infinite_sea_common::roster_id;
    use infinite_sea_common::roster_id::RosterId;
    use infinite_sea_common::roster_sequence_number;
    use infinite_sea_common::roster_status;
    use infinite_sea_common::speed_util;

    use infinite_sea::player;
    use infinite_sea::player::Player;
    use infinite_sea::roster::{Self, Roster};
    use infinite_sea::ship;

    const EEmptyRosterShipIds: u64 = 1;

    const EInvalidRosterStatus: u64 = 10;
    const ETargetCoordinatesNotSet: u64 = 11;
    const EInvalidRoasterUpdateTime: u64 = 12;
    const EOriginCoordinatesNotSet: u64 = 13;

    const EPayerHasNoClaimedIsland: u64 = 21;
    //const ERosterNotAnchoredAtIsland: u64 = 22;
    const ERosterIsUnassignedShips: u64 = 23;
    const EInconsistentRosterShipId: u64 = 24;
    const ERosterIsFull: u64 = 25;
    const EIsEnvironmentRoster: u64 = 26;
    const ERosterIslandNotCloseEnough: u64 = 27;

    const MIN_DISTANCE_TO_TRANSFER: u64 = 250;

    public fun are_rosters_close_enough_to_transfer(roster_1: &Roster, roster_2: &Roster): bool {
        let c_1 = roster::updated_coordinates(roster_1);
        let c_2 = roster::updated_coordinates(roster_2);
        let d = direct_route_util::get_distance(c_1, c_2);
        d <= MIN_DISTANCE_TO_TRANSFER
    }

    /// Assert that the ships in the roster are not full.
    public fun assert_roster_ships_not_full(roster: &Roster) {
        let ship_ids = roster::borrow_ship_ids(roster);
        assert!(vector::length(ship_ids) < 4, ERosterIsFull);
    }

    /// Assert that ths "ships" in the roster are not empty.
    public fun assert_roster_ships_not_empty(roster: &Roster) {
        let ship_ids = roster::borrow_ship_ids(roster);
        assert!(vector::length(ship_ids) > 0, EEmptyRosterShipIds);
    }

    /// Assert that the roster is NOT the special roster "unassigned ships".
    public fun assert_roster_is_not_unassigned_ships(roster: &Roster) {
        let roster_id = roster::roster_id(roster);
        assert!(
            roster_id::sequence_number(&roster_id) != roster_sequence_number::unassigned_ships(),
            ERosterIsUnassignedShips
        );
    }

    /// Assert that the roster is anchored at the island claimed by the player.
    public fun assert_roster_island_close_enough_to_transfer(roster: &Roster, player: &Player) {
        //let status = roster::status(roster);
        //assert!(status == roster_status::at_anchor(), EInvalidRosterStatus);
        assert!(!roster::environment_owned(roster), EIsEnvironmentRoster);
        let claimed_island_coordinates_o = player::claimed_island(player);
        assert!(option::is_some(&claimed_island_coordinates_o), EPayerHasNoClaimedIsland);
        let c_1 = roster::updated_coordinates(roster);
        let c_2 = *option::borrow(&claimed_island_coordinates_o);
        //assert!(roster_coordinates == *option::borrow(&claimed_island_coordinates), ERosterNotAnchoredAtIsland);
        assert!(direct_route_util::get_distance(c_1, c_2) < MIN_DISTANCE_TO_TRANSFER, ERosterIslandNotCloseEnough);
    }

    /// Wether the sequence number of the "player" roster is valid.
    public fun is_valid_roster_id_sequence_number(roster_id: &RosterId): bool {
        roster_id::sequence_number(roster_id) <= roster_sequence_number::fourth(
        ) // todo Hardcoded max roster sequence number?
    }

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
        if (l == 0) {
            return 0
        };
        while (i < l) {
            let ship_id = *vector::borrow(ship_ids, i);
            assert!(object_table::contains(ships, ship_id), EInconsistentRosterShipId);
            let ship = object_table::borrow(ships, ship_id);
            speed = speed + ship::speed(ship);
            i = i + 1;
        };
        speed / (l as u32)
    }

    /// Returns true if all ships in the roster are destroyed except the ship with the given ID.
    public fun is_destroyed_except_ship(roster: &Roster, ship: ID): bool {
        let ship_ids = roster::borrow_ship_ids(roster);
        let ships = roster::borrow_ships(roster);
        let i = 0;
        let l = vector::length(ship_ids);
        while (i < l) {
            let ship_id = *vector::borrow(ship_ids, i);
            if (ship_id == ship) {
                i = i + 1;
                continue
            };
            let ship = object_table::borrow(ships, ship_id);
            if (ship::health_points(ship) > 0) {
                return false
            };
            i = i + 1;
        };
        true
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

    public fun get_last_ship_id(roster: &Roster): ID {
        let ship_ids = roster::borrow_ship_ids(roster);
        let l = vector::length(ship_ids);
        assert!(l > 0, EEmptyRosterShipIds);
        *vector::borrow(ship_ids, l - 1)
    }

    /// Wether the status of the roster is battle ready.
    public fun is_status_battle_ready(roster: &Roster): bool {
        let s = roster::status(roster);
        s == roster_status::at_anchor() || s == roster_status::underway()
    }

    /// Check if s the roster's current location updatable.
    public fun is_current_location_updatable(
        roster: &Roster,
        clock: &Clock,
        updated_coordinates: Coordinates
    ): (bool, u64, u8) {
        let old_status = roster::status(roster);
        let coordinates_updated_at = roster::coordinates_updated_at(roster);
        if (coordinates::x(&updated_coordinates) == 0 || coordinates::y(&updated_coordinates) == 0) {
            return (false, coordinates_updated_at, old_status)
        };
        let target_coordinates_o = roster::target_coordinates(roster);
        let origin_coordinates_o = roster::origin_coordinates(roster);
        assert!(roster_status::underway() == old_status, EInvalidRosterStatus);
        assert!(option::is_some(&target_coordinates_o), ETargetCoordinatesNotSet);
        assert!(option::is_some(&origin_coordinates_o), EOriginCoordinatesNotSet);

        let target_coordinates = option::extract(&mut target_coordinates_o);
        let origin_coordinates = option::extract(&mut origin_coordinates_o);
        let new_status = old_status;
        let (speed_numerator, speed_denominator) = speed_util::speed_property_to_coordinate_units_per_second(
            roster::speed(roster)
        );
        let now_time = clock::timestamp_ms(clock) / 1000;
        assert!(now_time >= coordinates_updated_at, EInvalidRoasterUpdateTime);
        let elapsed_time = now_time - coordinates_updated_at;

        // TODO: Implement the rest of the function
        let updatable = true;
        let _ = speed_numerator;
        let _ = speed_denominator;
        let _ = elapsed_time;
        let _ = origin_coordinates;

        if (target_coordinates == updated_coordinates) {
            new_status = roster_status::at_anchor();
        };
        coordinates_updated_at = now_time;
        (updatable, coordinates_updated_at, new_status)
    }

    // /// Return current location of the roster, the now time and the new status of the roster.
    // public fun calculate_current_location(roster: &Roster, clock: &Clock): (Coordinates, u64, u8) {
    //     let old_status = roster::status(roster);
    //     let target_coordinates_o = roster::target_coordinates(roster);
    //     assert!(roster_status::underway() == old_status, EInvalidRosterStatus);
    //     assert!(option::is_some(&target_coordinates_o), ETargetCoordinatesNotSet);
    //
    //     let target_coordinates = option::extract(&mut target_coordinates_o);
    //     let updated_coordinates = roster::updated_coordinates(roster);
    //     let coordinates_updated_at = roster::coordinates_updated_at(roster);
    //     let new_status = old_status;
    //     let (speed_numerator, speed_denominator) = speed_util::speed_property_to_coordinate_units_per_second(
    //         roster::speed(roster)
    //     );
    //     let now_time = clock::timestamp_ms(clock) / 1000;
    //     assert!(now_time >= coordinates_updated_at, EInvalidRoasterUpdateTime);
    //     let elapsed_time = now_time - coordinates_updated_at;
    //     updated_coordinates = direct_route_util::calculate_current_location(
    //         updated_coordinates, target_coordinates,
    //         speed_numerator, speed_denominator, elapsed_time
    //     );
    //     if (target_coordinates == updated_coordinates) {
    //         new_status = roster_status::at_anchor();
    //     };
    //     coordinates_updated_at = now_time;
    //     (updated_coordinates, coordinates_updated_at, new_status)
    // }
}
