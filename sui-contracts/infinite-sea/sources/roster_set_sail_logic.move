#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::roster_set_sail_logic {
    use std::option;
    use std::vector;

    use sui::balance;
    use sui::balance::Balance;
    use sui::clock;
    use sui::clock::Clock;
    use sui::tx_context::TxContext;
    use infinite_sea_coin::energy::ENERGY;
    use infinite_sea_common::coordinates::Coordinates;
    use infinite_sea_common::roster_status;
    use infinite_sea_common::speed_util;

    use infinite_sea::permission_util;
    use infinite_sea::player::Player;
    use infinite_sea::roster;
    use infinite_sea::roster_util;

    friend infinite_sea::roster_aggregate;

    const ERosterUnfitToSail: u64 = 10;
    const ENotEnoughEnergy: u64 = 11;
    const EIllegalSailDuration: u64 = 12;
    const EInvalidUpdatedCoordinates: u64 = 101;

    const ENERGY_AMOUNT_PER_SECOND_PER_SHIP: u64 = 1388889;
    //const MIN_SAIL_ENERGY: u64 = 500;

    public(friend) fun verify(
        player: &Player,
        target_coordinates: Coordinates,
        clock: &Clock,
        energy: &Balance<ENERGY>,
        sail_duration: u64,
        updated_coordinates: Coordinates,
        roster: &roster::Roster,
        ctx: &TxContext,
    ): roster::RosterSetSail {
        //let roster_id = roster::roster_id(roster);
        permission_util::assert_sender_is_player_owner(player, ctx);
        permission_util::assert_player_is_roster_owner(player, roster);
        roster_util::assert_roster_is_not_unassigned_ships(roster);
        roster_util::assert_roster_ships_not_empty(roster);

        let new_updated_coordinates: Coordinates; // current location of the roster
        let status = roster::status(roster);
        if (status == roster_status::at_anchor()) {
            new_updated_coordinates = roster::updated_coordinates(roster);
        } else if (status == roster_status::underway()) {
            //let (_updated_coordinates, _coordinates_updated_at, _new_status) = roster_util::calculate_current_location(
            //    roster, clock
            //);
            // new_updated_coordinates = _updated_coordinates;
            let (updatable, _coordinates_updated_at, _new_status)
                = roster_util::is_current_location_updatable(roster, clock, updated_coordinates);
            if (updatable) {
                new_updated_coordinates = updated_coordinates;
            } else {
                // new_updated_coordinates = roster::updated_coordinates(roster);
                abort EInvalidUpdatedCoordinates
            };
        } else {
            abort ERosterUnfitToSail
        };
        let energy_cost = balance::value(energy);
        let total_time = speed_util::calculate_total_time(new_updated_coordinates, target_coordinates,
            roster::speed(roster));
        assert!(sail_duration >= total_time, EIllegalSailDuration);
        let ship_count = vector::length(roster::borrow_ship_ids(roster));
        //assert!(energy_cost >= MIN_SAIL_ENERGY, ENotEnoughEnergy);
        assert!(energy_cost >= total_time * ship_count * ENERGY_AMOUNT_PER_SECOND_PER_SHIP, ENotEnoughEnergy);
        let set_sail_at = clock::timestamp_ms(clock) / 1000;
        roster::new_roster_set_sail(roster, target_coordinates, sail_duration, set_sail_at,
            new_updated_coordinates, energy_cost)
    }

    public(friend) fun mutate(
        roster_set_sail: &roster::RosterSetSail,
        energy: Balance<ENERGY>,
        roster: &mut roster::Roster,
        ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        let target_coordinates = roster::roster_set_sail_target_coordinates(roster_set_sail);
        let set_sail_at = roster::roster_set_sail_set_sail_at(roster_set_sail);
        let updated_coordinates = roster::roster_set_sail_updated_coordinates(roster_set_sail);
        //let roster_id = roster::roster_id(roster);
        let sail_duration = roster::roster_set_sail_sail_duration(roster_set_sail);
        roster::set_updated_coordinates(roster, updated_coordinates); // update current location first
        roster::set_target_coordinates(roster, option::some(target_coordinates));
        roster::set_origin_coordinates(roster, option::some(updated_coordinates));
        roster::set_coordinates_updated_at(roster, set_sail_at);
        roster::set_set_sail_at(roster, option::some(set_sail_at));
        if (target_coordinates != updated_coordinates) {
            roster::set_status(roster, roster_status::underway());
        } else {
            roster::set_status(roster, roster_status::at_anchor());
        };
        roster::set_sail_duration(roster, sail_duration);
        let energy_vault = roster::borrow_mut_energy_vault(roster);
        balance::join(energy_vault, energy);
    }
}
