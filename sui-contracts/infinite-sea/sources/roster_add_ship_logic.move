#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::roster_add_ship_logic {
    use std::option::Option;

    use sui::object_table;
    use sui::tx_context::TxContext;

    use infinite_sea::roster;
    use infinite_sea::roster_util;
    use infinite_sea::ship;
    use infinite_sea::ship::Ship;

    friend infinite_sea::roster_aggregate;

    public(friend) fun verify(
        ship: &Ship,
        position: Option<u64>,
        roster: &roster::Roster,
        ctx: &TxContext,
    ): roster::RosterShipAdded {
        roster::new_roster_ship_added(roster, position)
    }

    public(friend) fun mutate(
        roster_ship_added: &mut roster::RosterShipAdded,
        ship: Ship,
        roster: &mut roster::Roster,
        ctx: &mut TxContext, // modify the reference to mutable if needed
    ) {
        //let roster_id = roster::roster_id(roster);
        let position = roster::roster_ship_added_position(roster_ship_added);
        let ship_ids = roster::borrow_mut_ship_ids(roster);
        let ship_id = ship::id(&ship);
        roster_util::add_ship_id(ship_ids, ship_id, position);
        let ships = roster::borrow_mut_ships(roster);
        object_table::add(ships, ship_id, ship);
        let speed = roster_util::calculate_roster_speed(roster);
        roster::set_speed(roster, speed);
    }
}
