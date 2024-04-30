#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::roster_adjust_ships_position_logic {
    use infinite_sea::player::{Self, Player};
    use infinite_sea::roster;
    use sui::object::ID;
    use sui::tx_context::{Self, TxContext};

    friend infinite_sea::roster_aggregate;

    public(friend) fun verify(
        player: &Player,
        positions: vector<u64>,
        ship_ids: vector<ID>,
        roster: &roster::Roster,
        ctx: &TxContext,
    ): roster::RosterShipsPositionAdjusted {
        //todo
        roster::new_roster_ships_position_adjusted(roster, positions, ship_ids)
    }

    public(friend) fun mutate(
        roster_ships_position_adjusted: &roster::RosterShipsPositionAdjusted,
        roster: &mut roster::Roster,
        ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        let positions = roster::roster_ships_position_adjusted_positions(roster_ships_position_adjusted);
        let ship_ids = roster::roster_ships_position_adjusted_ship_ids(roster_ships_position_adjusted);
        let roster_id = roster::roster_id(roster);
        // todo ...
        //
    }

}
