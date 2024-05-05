#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::roster_put_in_ship_inventory_logic {
    use std::option;
    use std::vector;

    use sui::clock::Clock;
    use sui::object::ID;
    use sui::object_table;
    use sui::tx_context::TxContext;
    use infinite_sea_common::item_id_quantity_pairs;
    use infinite_sea_common::item_id_quantity_pairs::ItemIdQuantityPairs;
    use infinite_sea_common::roster_status;
    use infinite_sea_common::vector_util;

    use infinite_sea::permission_util;
    use infinite_sea::player::{Self, Player};
    use infinite_sea::roster;
    use infinite_sea::roster_util;
    use infinite_sea::ship;

    friend infinite_sea::roster_aggregate;


    public(friend) fun verify(
        player: &mut Player,
        clock: &Clock,
        ship_id: ID,
        item_id_quantity_pairs: ItemIdQuantityPairs,
        roster: &mut roster::Roster,
        ctx: &TxContext,
    ): roster::RosterShipInventoryPutIn {
        permission_util::assert_sender_is_player_owner(player, ctx);
        permission_util::assert_player_is_roster_owner(player, roster);

        // Check if the ship has anchored at the island
        if (roster::status(roster) == roster_status::underway()) {
            let (updated_coordinates, coordinates_updated_at, new_status)
                = roster_util::calculate_current_location(roster, clock);
            roster::set_updated_coordinates(roster, updated_coordinates);
            roster::set_coordinates_updated_at(roster, coordinates_updated_at);
            roster::set_status(roster, new_status);
        };
        roster_util::assert_roster_is_anchored_at_claimed_island(roster, player);

        roster::new_roster_ship_inventory_put_in(roster, ship_id, item_id_quantity_pairs)
    }

    public(friend) fun mutate(
        roster_ship_inventory_put_in: &roster::RosterShipInventoryPutIn,
        player: &mut Player,
        roster: &mut roster::Roster,
        ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        let ship_id = roster::roster_ship_inventory_put_in_ship_id(roster_ship_inventory_put_in);
        let item_id_quantity_pairs = roster::roster_ship_inventory_put_in_item_id_quantity_pairs(
            roster_ship_inventory_put_in
        );
        //let roster_id = roster::roster_id(roster);
        let ships = roster::borrow_mut_ships(roster);
        let ship = object_table::borrow_mut(ships, ship_id);
        let ship_inv = ship::borrow_mut_inventory(ship);
        let player_inv = player::borrow_mut_inventory(player);
        let items = item_id_quantity_pairs::items(&item_id_quantity_pairs);
        let i = 0;
        let l = vector::length(&items);
        while (i < l) {
            let item = vector::borrow(&items, i);
            vector_util::subtract_item_id_quantity_pair(player_inv, *item); // - item from player
            vector_util::insert_or_add_item_id_quantity_pair(ship_inv, *item); // + item to ship
            i = i + 1;
        };
    }
}
