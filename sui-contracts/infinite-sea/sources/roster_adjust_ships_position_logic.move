#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::roster_adjust_ships_position_logic {
    use std::option;
    use std::vector;

    use sui::object::ID;
    use sui::tx_context::TxContext;
    use infinite_sea_common::ship_util;

    use infinite_sea::permission_util;
    use infinite_sea::player::Player;
    use infinite_sea::roster;

    friend infinite_sea::roster_aggregate;

    const EShipIdsAndPositionsLengthMismatch: u64 = 10;
    const EShipIdNotFound: u64 = 11;

    public(friend) fun verify(
        player: &Player,
        positions: vector<u64>,
        ship_ids: vector<ID>,
        roster: &roster::Roster,
        ctx: &TxContext,
    ): roster::RosterShipsPositionAdjusted {
        permission_util::assert_sender_is_player_owner(player, ctx);
        permission_util::assert_player_is_roster_owner(player, roster);
        assert!(vector::length(&ship_ids) == vector::length(&positions), EShipIdsAndPositionsLengthMismatch);

        roster::new_roster_ships_position_adjusted(roster, positions, ship_ids)
    }

    public(friend) fun mutate(
        roster_ships_position_adjusted: &roster::RosterShipsPositionAdjusted,
        roster: &mut roster::Roster,
        ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        //let roster_id = roster::roster_id(roster);
        let new_positions = roster::roster_ships_position_adjusted_positions(roster_ships_position_adjusted);
        let adjusted_ship_ids = roster::roster_ships_position_adjusted_ship_ids(roster_ships_position_adjusted);
        let i = 0;
        let l = vector::length(&new_positions);
        let roster_ship_ids = roster::ship_ids(roster);
        while (i < l) {
            let ship_id = *vector::borrow(&adjusted_ship_ids, i);
            let new_position = *vector::borrow(&new_positions, i);
            let old_position_o = ship_util::find_ship_id(&roster_ship_ids, ship_id);
            assert!(option::is_some(&old_position_o), EShipIdNotFound);
            let old_position = option::extract(&mut old_position_o);
            if (old_position != new_position) {
                vector::remove(&mut roster_ship_ids, old_position);
                vector::insert(&mut roster_ship_ids, ship_id, new_position);
            };
            i = i + 1;
        };
        roster::set_ship_ids(roster, roster_ship_ids);
    }
}
