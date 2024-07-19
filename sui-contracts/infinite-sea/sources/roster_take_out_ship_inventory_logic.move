#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::roster_take_out_ship_inventory_logic {
    use std::vector;
    use sui::clock::Clock;

    use sui::object::ID;
    use sui::object_table;
    use sui::tx_context::TxContext;
    use infinite_sea_common::coordinates::Coordinates;
    use infinite_sea::roster_util;
    use infinite_sea::permission_util;
    use infinite_sea_common::item_id_quantity_pairs;
    use infinite_sea_common::item_id_quantity_pairs::ItemIdQuantityPairs;
    use infinite_sea_common::roster_status;
    use infinite_sea_common::sorted_vector_util;

    use infinite_sea::player::{Self, Player};
    use infinite_sea::roster;
    use infinite_sea::ship;

    friend infinite_sea::roster_aggregate;

    public(friend) fun verify(
        player: &mut Player,
        clock: &Clock,
        ship_id: ID,
        item_id_quantity_pairs: ItemIdQuantityPairs,
        updated_coordinates: Coordinates,
        roster: &mut roster::Roster,
        ctx: &TxContext,
    ): roster::RosterShipInventoryTakenOut {
        permission_util::assert_sender_is_player_owner(player, ctx);
        permission_util::assert_player_is_roster_owner(player, roster);
        roster_util::assert_roster_is_not_unassigned_ships(roster); // Is this necessary?

        // Check if the ship has anchored at the island
        if (roster::status(roster) == roster_status::underway()) {
            // let (updated_coordinates, coordinates_updated_at, new_status)
            //     = roster_util::calculate_current_location(roster, clock);
            let (updatable, coordinates_updated_at, new_status)
                = roster_util::is_current_location_updatable(roster, clock, updated_coordinates);
            if (updatable) {
                roster::set_updated_coordinates(roster, updated_coordinates);
                roster::set_coordinates_updated_at(roster, coordinates_updated_at);
                roster::set_status(roster, new_status);
            }
        };
        roster_util::assert_roster_is_anchored_at_claimed_island(roster, player);

        roster::new_roster_ship_inventory_taken_out(roster, ship_id, item_id_quantity_pairs, updated_coordinates)
    }

    public(friend) fun mutate(
        roster_ship_inventory_taken_out: &roster::RosterShipInventoryTakenOut,
        player: &mut Player,
        roster: &mut roster::Roster,
        ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        let ship_id = roster::roster_ship_inventory_taken_out_ship_id(roster_ship_inventory_taken_out);
        let item_id_quantity_pairs = roster::roster_ship_inventory_taken_out_item_id_quantity_pairs(
            roster_ship_inventory_taken_out
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
            sorted_vector_util::subtract_item_id_quantity_pair(ship_inv, *item); // - item from ship
            sorted_vector_util::insert_or_add_item_id_quantity_pair(player_inv, *item); // + item to player
            i = i + 1;
        };
    }
}
