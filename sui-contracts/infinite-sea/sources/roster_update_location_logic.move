#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::roster_update_location_logic {
    use std::option;

    use sui::clock;
    use sui::clock::Clock;
    use sui::tx_context::TxContext;
    use infinite_sea_common::direct_route_util;
    use infinite_sea_common::roster_status;
    use infinite_sea_common::speed_util;

    use infinite_sea::roster;

    friend infinite_sea::roster_aggregate;

    const EInvalidRoasterStatus: u64 = 10;
    const ETargetCoordinatesNotSet: u64 = 11;
    const EInvalidRoasterUpdateTime: u64 = 12;

    public(friend) fun verify(
        clock: &Clock,
        roster: &roster::Roster,
        ctx: &TxContext,
    ): roster::RosterLocationUpdated {
        let old_status = roster::status(roster);
        let target_coordinates_o = roster::target_coordinates(roster);
        assert!(roster_status::underway() == old_status, EInvalidRoasterStatus);
        assert!(option::is_some(&target_coordinates_o), ETargetCoordinatesNotSet);

        let target_coordinates = option::extract(&mut target_coordinates_o);
        let updated_coordinates = roster::updated_coordinates(roster);
        let coordinates_updated_at = roster::coordinates_updated_at(roster);
        let new_status = old_status;
        let (speed_numerator, speed_denominator) = speed_util::speed_to_coordinate_units_per_second(
            roster::speed(roster)
        );
        let now_time = clock::timestamp_ms(clock) / 1000;
        assert!(now_time >= coordinates_updated_at, EInvalidRoasterUpdateTime);
        let elapsed_time = now_time - coordinates_updated_at;
        updated_coordinates = direct_route_util::calculate_current_location(
            updated_coordinates, target_coordinates,
            speed_numerator, speed_denominator, elapsed_time
        );
        if (target_coordinates == updated_coordinates) {
            new_status = roster_status::at_anchor();
        };
        coordinates_updated_at = now_time;
        roster::new_roster_location_updated(roster, updated_coordinates, coordinates_updated_at, new_status)
    }

    public(friend) fun mutate(
        roster_location_updated: &roster::RosterLocationUpdated,
        roster: &mut roster::Roster,
        ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        let updated_coordinates = roster::roster_location_updated_updated_coordinates(roster_location_updated);
        let coordinates_updated_at = roster::roster_location_updated_coordinates_updated_at(roster_location_updated);
        let new_status = roster::roster_location_updated_new_status(roster_location_updated);
        //let roster_id = roster::roster_id(roster);

        roster::set_updated_coordinates(roster, updated_coordinates);
        roster::set_coordinates_updated_at(roster, coordinates_updated_at);
        roster::set_status(roster, new_status);
    }
}
