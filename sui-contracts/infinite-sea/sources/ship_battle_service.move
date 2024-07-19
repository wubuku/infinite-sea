module infinite_sea::ship_battle_service {
    use sui::clock::Clock;
    use sui::tx_context;
    use infinite_sea_common::battle_status;
    use infinite_sea_common::ship_battle_command;

    use infinite_sea::player::Player;
    use infinite_sea::roster::Roster;
    use infinite_sea::ship_battle;
    use infinite_sea::ship_battle::ShipBattle;
    use infinite_sea::ship_battle_aggregate;

    const MAX_NUMBER_OF_ROUNDS: u64 = 100;

    public entry fun initiate_battle_and_auto_play_till_end(
        player: &mut Player,
        initiator: &mut Roster,
        responder: &mut Roster,
        clock: &Clock,
        initiator_coordinates_x: u32,
        initiator_coordinates_y: u32,
        responder_coordinates_x: u32,
        responder_coordinates_y: u32,
        ctx: &mut tx_context::TxContext,
    ) {
        let ship_battle = ship_battle_aggregate::initiate_battle(
            player,
            initiator,
            responder,
            clock,
            initiator_coordinates_x,
            initiator_coordinates_y,
            responder_coordinates_x,
            responder_coordinates_y,
            ctx,
        );
        auto_play_till_end(&mut ship_battle, player, initiator, responder, clock, ctx);
        ship_battle::share_object(ship_battle);
    }

    public entry fun initiate_battle(
        player: &mut Player,
        initiator: &mut Roster,
        responder: &mut Roster,
        clock: &Clock,
        initiator_coordinates_x: u32,
        initiator_coordinates_y: u32,
        responder_coordinates_x: u32,
        responder_coordinates_y: u32,
        ctx: &mut tx_context::TxContext,
    ) {
        let ship_battle = ship_battle_aggregate::initiate_battle(
            player,
            initiator,
            responder,
            clock,
            initiator_coordinates_x,
            initiator_coordinates_y,
            responder_coordinates_x,
            responder_coordinates_y,
            ctx,
        );
        ship_battle::share_object(ship_battle);
    }

    public entry fun auto_play_till_end(
        ship_battle: &mut ShipBattle,
        player: &mut Player,
        initiator: &mut Roster,
        responder: &mut Roster,
        clock: &Clock,
        ctx: &mut tx_context::TxContext,
    ) {
        let battle_status = ship_battle::status(ship_battle);
        let i = 0;
        while (battle_status != battle_status::ended()) {
            if (i >= MAX_NUMBER_OF_ROUNDS) {
                break
            };
            ship_battle_aggregate::make_move(ship_battle, player, initiator, responder, clock,
                ship_battle_command::attack(),
                ctx,
            );
            battle_status = ship_battle::status(ship_battle);
            i = i + 1;
        };
    }
}
