#[allow(unused_mut_parameter)]
module infinite_sea::player_create_logic {
    use std::vector;

    use sui::tx_context::TxContext;

    use infinite_sea::player;

    friend infinite_sea::player_aggregate;

    public(friend) fun verify(
        ctx: &mut TxContext,
    ): player::PlayerCreated {
        let _ = ctx;
        let owner = sui::tx_context::sender(ctx);
        player::new_player_created(
            owner,
        )
    }

    public(friend) fun mutate(
        player_created: &player::PlayerCreated,
        ctx: &mut TxContext,
    ): player::Player {
        let owner = player::player_created_owner(player_created);
        player::new_player(
            owner,
            vector::empty(),
            ctx,
        )
    }
}
