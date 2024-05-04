#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::roster_update_location_logic {
    use sui::clock::Clock;
    use sui::tx_context::TxContext;

    use infinite_sea::roster;
    use infinite_sea::roster_util;

    friend infinite_sea::roster_aggregate;


    public(friend) fun verify(
        clock: &Clock,
        roster: &roster::Roster,
        ctx: &TxContext,
    ): roster::RosterLocationUpdated {
        let (updated_coordinates, coordinates_updated_at, new_status) = roster_util::calculate_current_location(
            roster, clock
        );
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
