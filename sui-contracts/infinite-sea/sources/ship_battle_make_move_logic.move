#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::ship_battle_make_move_logic {
    use std::option;
    use sui::clock;
    use sui::clock::Clock;
    use sui::tx_context::TxContext;

    use infinite_sea::permission_util;
    use infinite_sea::player::Player;
    use infinite_sea::roster::Roster;
    use infinite_sea::ship_battle;
    use infinite_sea::ship_battle_util;

    friend infinite_sea::ship_battle_aggregate;

    public(friend) fun verify(
        player: &Player,
        initiator: &mut Roster,
        responder: &mut Roster,
        clock: &Clock,
        attacker_command: u8,
        defender_command: u8,
        ship_battle: &ship_battle::ShipBattle,
        ctx: &TxContext,
    ): ship_battle::ShipBattleMoveMade {
        permission_util::assert_sender_is_player_owner(player, ctx);
        ship_battle_util::assert_palyer_is_current_round_mover(player, ship_battle, initiator, responder);
        let now_time = clock::timestamp_ms(clock) / 1000;

        ship_battle::new_ship_battle_move_made(ship_battle, attacker_command, defender_command,
            ship_battle::round_number(ship_battle),
            0,//todo
            0,//todo
            now_time,
            option::none(),//todo
            option::none(),
            option::none(),
        )
    }

    public(friend) fun mutate(
        ship_battle_move_made: &mut ship_battle::ShipBattleMoveMade,
        initiator: &mut Roster,
        responder: &mut Roster,
        ship_battle: &mut ship_battle::ShipBattle,
        ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        let attacker_command = ship_battle::ship_battle_move_made_attacker_command(ship_battle_move_made);
        let id = ship_battle::id(ship_battle);
        // todo ...
        //
    }
}
