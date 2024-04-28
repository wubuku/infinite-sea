#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::roster_set_sail_logic {
    use std::option;

    use sui::clock;
    use sui::clock::Clock;
    use sui::tx_context::TxContext;
    use infinite_sea_common::coordinates::Coordinates;
    use infinite_sea_common::roster_status;

    use infinite_sea::roster;

    friend infinite_sea::roster_aggregate;

    public(friend) fun verify(
        target_coordinates: Coordinates,
        clock: &Clock,
        roster: &roster::Roster,
        ctx: &TxContext,
    ): roster::RosterSetSail {
        let roster_id = roster::roster_id(roster);
        //todo check ownership
        //todo check if the roster is at anchor
        //todo check if the roster is already underway
        let updated_coordinates = roster::updated_coordinates(roster);
        roster::new_roster_set_sail(roster, target_coordinates, clock::timestamp_ms(clock) / 1000, updated_coordinates)
    }

    public(friend) fun mutate(
        roster_set_sail: &roster::RosterSetSail,
        roster: &mut roster::Roster,
        ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        let target_coordinates = roster::roster_set_sail_target_coordinates(roster_set_sail);
        let set_sail_at = roster::roster_set_sail_set_sail_at(roster_set_sail);
        let updated_coordinates = roster::roster_set_sail_updated_coordinates(roster_set_sail);
        //let roster_id = roster::roster_id(roster);

        roster::set_status(roster, roster_status::underway());
        roster::set_updated_coordinates(roster, updated_coordinates);
        roster::set_target_coordinates(roster, option::some(target_coordinates));
        roster::set_coordinates_updated_at(roster, set_sail_at);
    }
}
