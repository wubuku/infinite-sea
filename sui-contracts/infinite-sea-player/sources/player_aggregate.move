// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

module infinite_sea_player::player_aggregate {
    use infinite_sea_player::player;
    use infinite_sea_player::player_airdrop_logic;
    use infinite_sea_player::player_create_logic;
    use sui::tx_context;

    const EInvalidPublisher: u64 = 50;

    public entry fun create(
        level: u16,
        experience: u32,
        player_table: &mut player::PlayerTable,
        ctx: &mut tx_context::TxContext,
    ) {
        let player_created = player_create_logic::verify(
            level,
            experience,
            player_table,
            ctx,
        );
        let player = player_create_logic::mutate(
            &player_created,
            player_table,
            ctx,
        );
        player::set_player_created_id(&mut player_created, player::id(&player));
        player::share_object(player);
        player::emit_player_created(player_created);
    }

    public entry fun airdrop(
        player: &mut player::Player,
        publisher: &sui::package::Publisher,
        item_id: u32,
        quantity: u64,
        ctx: &mut tx_context::TxContext,
    ) {
        assert!(sui::package::from_package<player::Player>(publisher), EInvalidPublisher);
        let player_airdropped = player_airdrop_logic::verify(
            item_id,
            quantity,
            player,
            ctx,
        );
        player_airdrop_logic::mutate(
            &player_airdropped,
            player,
            ctx,
        );
        player::update_object_version(player);
        player::emit_player_airdropped(player_airdropped);
    }

}
