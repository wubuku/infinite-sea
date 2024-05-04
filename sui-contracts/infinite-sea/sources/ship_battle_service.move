module infinite_sea::ship_battle_service {
    use sui::clock::Clock;
    use sui::tx_context::Self;
    use infinite_sea_common::battle_status;
    use infinite_sea_common::ship_battle_command;

    use infinite_sea::player::Player;
    use infinite_sea::roster::Roster;
    use infinite_sea::ship_battle;
    use infinite_sea::ship_battle_aggregate;

    public entry fun initiate_battle_and_auto_play_till_end(
        player: &mut Player,
        initiator: &mut Roster,
        responder: &mut Roster,
        clock: &Clock,
        ctx: &mut tx_context::TxContext,
    ) {
        let ship_battle = ship_battle_aggregate::initiate_battle(
            player,
            initiator,
            responder,
            clock,
            ctx,
        );
        let battle_status = ship_battle::status(&ship_battle);
        while (battle_status != battle_status::ended()) {
            ship_battle_aggregate::make_move(&mut ship_battle, player, initiator, responder, clock,
                ship_battle_command::attack(),
                ctx,
            );
            battle_status = ship_battle::status(&ship_battle);
        };
        ship_battle::share_object(ship_battle);
    }
}
