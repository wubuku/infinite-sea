#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::roster_transfer_ship_inventory_logic {
    use infinite_sea::player::{Self, Player};
    use infinite_sea::roster;
    use infinite_sea_common::item_id_quantity_pairs::ItemIdQuantityPairs;
    use sui::object::ID;
    use sui::tx_context::{Self, TxContext};
    use infinite_sea::permission_util;

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
        let item_id_quantity_pairs = roster::roster_ship_inventory_transferred_item_id_quantity_pairs(roster_ship_inventory_transferred);
        let roster_id = roster::roster_id(roster);
        // todo ...
        //
    }

}
