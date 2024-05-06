#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::player_airdrop_logic {
    use sui::tx_context::TxContext;
    use infinite_sea_common::item_id_quantity_pair;
    use infinite_sea_common::sorted_vector_util;

    use infinite_sea::player;

    friend infinite_sea::player_aggregate;

    public(friend) fun verify(
        item_id: u32,
        quantity: u32,
        player: &player::Player,
        ctx: &TxContext,
    ): player::PlayerAirdropped {
        player::new_player_airdropped(
            player,
            item_id,
            quantity,
        )
    }

    public(friend) fun mutate(
        player_airdropped: &player::PlayerAirdropped,
        player: &mut player::Player,
        ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        let item_id = player::player_airdropped_item_id(player_airdropped);
        let quantity = player::player_airdropped_quantity(player_airdropped);
        let inv = player::borrow_mut_inventory(player);
        sorted_vector_util::insert_or_add_item_id_quantity_pair(inv, item_id_quantity_pair::new(item_id, quantity));
    }
}
