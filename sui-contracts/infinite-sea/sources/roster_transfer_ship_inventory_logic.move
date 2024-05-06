#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::roster_transfer_ship_inventory_logic {
    use sui::object::ID;
    use sui::object_table;
    use sui::tx_context::TxContext;
    use infinite_sea_common::item_id_quantity_pairs;
    use infinite_sea_common::item_id_quantity_pairs::ItemIdQuantityPairs;
    use infinite_sea_common::sorted_vector_util;

    use infinite_sea::permission_util;
    use infinite_sea::player::Player;
    use infinite_sea::roster;
    use infinite_sea::ship;

    friend infinite_sea::roster_aggregate;

    public(friend) fun verify(
        player: &Player,
        from_ship_id: ID,
        to_ship_id: ID,
        item_id_quantity_pairs: ItemIdQuantityPairs,
        roster: &roster::Roster,
        ctx: &TxContext,
    ): roster::RosterShipInventoryTransferred {
        permission_util::assert_sender_is_player_owner(player, ctx);
        permission_util::assert_player_is_roster_owner(player, roster);
        //todo more checks
        roster::new_roster_ship_inventory_transferred(roster, from_ship_id, to_ship_id, item_id_quantity_pairs)
    }

    public(friend) fun mutate(
        roster_ship_inventory_transferred: &roster::RosterShipInventoryTransferred,
        roster: &mut roster::Roster,
        ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        let from_ship_id = roster::roster_ship_inventory_transferred_from_ship_id(roster_ship_inventory_transferred);
        let to_ship_id = roster::roster_ship_inventory_transferred_to_ship_id(roster_ship_inventory_transferred);
        let item_id_quantity_pairs = roster::roster_ship_inventory_transferred_item_id_quantity_pairs(
            roster_ship_inventory_transferred
        );
        //let roster_id = roster::roster_id(roster);

        let ships = roster::borrow_mut_ships(roster);
        let form_ship = object_table::borrow_mut(ships, from_ship_id);
        let from_inv = ship::borrow_mut_inventory(form_ship);
        sorted_vector_util::subtract_item_id_quantity_pairs(
            from_inv,
            &item_id_quantity_pairs::items(&item_id_quantity_pairs)
        );

        let to_ship = object_table::borrow_mut(ships, to_ship_id);
        let to_inv = ship::borrow_mut_inventory(to_ship);
        sorted_vector_util::merge_item_id_quantity_pairs(
            to_inv,
            &item_id_quantity_pairs::items(&item_id_quantity_pairs)
        );
    }
}
