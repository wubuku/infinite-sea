#[allow(unused_mut_parameter)]
module infinite_sea::player_create_logic {
    use infinite_sea::player;
    use sui::tx_context::TxContext;

    friend infinite_sea::player_aggregate;

    public(friend) fun verify(
        level: u16,
        experience: u32,
        player_table: &player::PlayerTable,
        ctx: &mut TxContext,
    ): player::PlayerCreated {
        let player_id = sui::tx_context::sender(ctx);
        player::asset_player_id_not_exists(player_id, player_table);
        player::new_player_created(
            player_id,
            level,
            experience,
        )
    }

    public(friend) fun mutate(
        player_created: &player::PlayerCreated,
        player_table: &mut player::PlayerTable,
        ctx: &mut TxContext,
    ): player::Player {
        let player_id = player::player_created_player_id(player_created);
        let level = player::player_created_level(player_created);
        let experience = player::player_created_experience(player_created);
        player::create_player(
            player_id,
            level,
            experience,
            player_table,
            ctx,
        )
    }

}
