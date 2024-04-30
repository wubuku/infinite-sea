#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::roster_put_in_ship_inventory_logic {
    use infinite_sea::player::{Self, Player};
    use infinite_sea::roster;
    use infinite_sea_common::item_id_quantity_pairs::ItemIdQuantityPairs;
    use sui::object::ID;
    use sui::tx_context::{Self, TxContext};

    friend infinite_sea::roster_aggregate;

    public(friend) fun verify(
        player: &mut Player,
        ship_id: ID,
        item_id_quantity_pairs: ItemIdQuantityPairs,
        roster: &roster::Roster,
        ctx: &TxContext,
    ): roster::RosterShipInventoryPutIn {
        //todo
        roster::new_roster_ship_inventory_put_in(roster, ship_id, item_id_quantity_pairs)
    }

    public(friend) fun mutate(
        roster_ship_inventory_put_in: &roster::RosterShipInventoryPutIn,
        player: &mut Player,
        roster: &mut roster::Roster,
        ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        let ship_id = roster::roster_ship_inventory_put_in_ship_id(roster_ship_inventory_put_in);
        let item_id_quantity_pairs = roster::roster_ship_inventory_put_in_item_id_quantity_pairs(roster_ship_inventory_put_in);
        let roster_id = roster::roster_id(roster);
        // todo ...
        //
    }

}
