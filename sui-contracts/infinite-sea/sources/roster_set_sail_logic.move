#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::roster_set_sail_logic {
    use std::option;

    use sui::clock;
    use sui::clock::Clock;
    use sui::tx_context::TxContext;
    use infinite_sea::roster_util;
    use infinite_sea_common::coordinates::Coordinates;
    use infinite_sea_common::roster_status;

    use infinite_sea::permission_util;
    use infinite_sea::player::Player;
    use infinite_sea::roster;

    friend infinite_sea::roster_aggregate;

    const ERosterUnfitToSail: u64 = 10;

    public(friend) fun verify(
        player: &Player,
        target_coordinates: Coordinates,
        clock: &Clock,
        roster: &roster::Roster,
        ctx: &TxContext,
    ): roster::RosterSetSail {
        //let roster_id = roster::roster_id(roster);
        permission_util::assert_sender_is_player_owner(player, ctx);
        permission_util::assert_player_is_roster_owner(player, roster);
        let updated_coordinates: Coordinates; // current location of the roster
        let status = roster::status(roster);
        if (status == roster_status::at_anchor()) {
            updated_coordinates = roster::updated_coordinates(roster);
        } else if (status == roster_status::underway()) {
            let (_updated_coordinates, _coordinates_updated_at, _new_status) = roster_util::calculate_current_location(
                roster, clock
            );
            updated_coordinates = _updated_coordinates;
        } else {
            abort ERosterUnfitToSail
        };

        let set_sail_at = clock::timestamp_ms(clock) / 1000;
        roster::new_roster_set_sail(roster, target_coordinates, set_sail_at, updated_coordinates)
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

        roster::set_updated_coordinates(roster, updated_coordinates); // update current location first
        roster::set_target_coordinates(roster, option::some(target_coordinates));
        roster::set_coordinates_updated_at(roster, set_sail_at);
        if (target_coordinates != updated_coordinates) {
            roster::set_status(roster, roster_status::underway());
        } else {
            roster::set_status(roster, roster_status::at_anchor());
        }
    }
}
