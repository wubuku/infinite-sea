#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::player_airdrop_logic {
    use sui::tx_context::TxContext;

    use infinite_sea::player;
    use infinite_sea::player_item;

    friend infinite_sea::player_aggregate;

    public(friend) fun verify(
        item_id: u32,
        quantity: u64,
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
        //let player_id = player::player_id(player);
        if (player::items_contains(player, item_id)) {
            let player_item = player_item::new_player_item(item_id, quantity);
            player::add_item(player, player_item);
        } else {
            let player_item = player::borrow_mut_item(player, item_id);
            let q = player_item::quantity(player_item) + quantity;
            player_item::set_quantity(player_item, q);
        };
    }
}
