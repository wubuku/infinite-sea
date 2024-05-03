#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::ship_battle_initiate_battle_logic {
    use std::option;
    use sui::clock;
    use sui::clock::Clock;
    use sui::tx_context::TxContext;
    use infinite_sea_common::roster_status;
    use infinite_sea::permission_util;
    use infinite_sea::player::Player;
    use infinite_sea::ship_battle_util;

    use infinite_sea::roster::{Self, Roster};
    use infinite_sea::ship_battle;

    friend infinite_sea::ship_battle_aggregate;

    public(friend) fun verify(
        player: &Player,
        initiator: &mut Roster,
        responder: &mut Roster,
        clock: &Clock,
        ctx: &mut TxContext,
    ): ship_battle::ShipBattleInitiated {
        permission_util::assert_sender_is_player_owner(player, ctx);
        permission_util::assert_player_is_roster_owner(player, initiator);

        // todo update and check rosters' statuses
        ship_battle::new_ship_battle_initiated(
            roster::id(initiator),
            roster::id(responder),
            clock::timestamp_ms(clock) / 1000,
            option::none(),//todo
            option::none(),
            option::none(),
        )
    }

    public(friend) fun mutate(
        ship_battle_initiated: &mut ship_battle::ShipBattleInitiated,
        initiator: &mut Roster,
        responder: &mut Roster,
        ctx: &mut TxContext,
    ): ship_battle::ShipBattle {
        let initiator_id = ship_battle::ship_battle_initiated_initiator_id(ship_battle_initiated);
        let opposing_side_id = ship_battle::ship_battle_initiated_responder_id(ship_battle_initiated);
        let started_at = ship_battle::ship_battle_initiated_started_at(ship_battle_initiated);
        let battle = ship_battle::new_ship_battle(
            initiator_id,
            opposing_side_id,
            0, //todo battle status?
            started_at,
            option::none(),//ship_battle_util::initiator(),
            option::none(),
            option::none(),
            ctx
        );
        let battle_id = ship_battle::id(&battle);
        // update rosters with battle ID
        roster::set_status(initiator, roster_status::in_battle());
        roster::set_ship_battle_id(initiator, option::some(battle_id));
        roster::set_status(responder, roster_status::in_battle());
        roster::set_ship_battle_id(responder, option::some(battle_id));
        battle
    }
}
