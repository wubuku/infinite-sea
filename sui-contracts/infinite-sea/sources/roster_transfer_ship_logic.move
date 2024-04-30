#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::roster_transfer_ship_logic {
    use infinite_sea::player::{Self, Player};
    use infinite_sea::roster::{Self, Roster};
    use std::option::{Self, Option};
    use sui::object::ID;
    use sui::tx_context::{Self, TxContext};

    friend infinite_sea::roster_aggregate;

    public(friend) fun verify(
        player: &Player,
        ship_id: ID,
        to_roster: &mut Roster,
        to_position: Option<u64>,
        roster: &roster::Roster,
        ctx: &TxContext,
    ): roster::RosterShipTransferred {
        let to_roster_id = roster::roster_id(to_roster);
        //todo
        roster::new_roster_ship_transferred(roster, ship_id, to_roster_id, to_position)
    }

    public(friend) fun mutate(
        roster_ship_transferred: &mut roster::RosterShipTransferred,
        to_roster: &mut Roster,
        roster: &mut roster::Roster,
        ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        let ship_id = roster::roster_ship_transferred_ship_id(roster_ship_transferred);
        let to_position = roster::roster_ship_transferred_to_position(roster_ship_transferred);
        let to_roster_id = roster::roster_ship_transferred_to_roster_id(roster_ship_transferred);
        let roster_id = roster::roster_id(roster);
        // todo ...
        //
    }

}
