#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::ship_battle_initiate_battle_logic {
    use sui::clock;
    use sui::clock::Clock;
    use sui::tx_context::TxContext;
    use infinite_sea::ship_battle_util;

    use infinite_sea::roster::{Self, Roster};
    use infinite_sea::ship_battle;

    friend infinite_sea::ship_battle_aggregate;

    public(friend) fun verify(
        initiator: &mut Roster,
        responder: &mut Roster,
        clock: &Clock,
        ctx: &mut TxContext,
    ): ship_battle::ShipBattleInitiated {
        // todo update and check rosters' statuses
        ship_battle::new_ship_battle_initiated(
            roster::id(initiator),
            roster::id(responder),
            clock::timestamp_ms(clock) / 1000,
        )
    }

    public(friend) fun mutate(
        ship_battle_initiated: &ship_battle::ShipBattleInitiated,
        initiator: &mut Roster,
        responder: &mut Roster,
        ctx: &mut TxContext,
    ): ship_battle::ShipBattle {
        let initiator_id = ship_battle::ship_battle_initiated_initiator_id(ship_battle_initiated);
        let opposing_side_id = ship_battle::ship_battle_initiated_responder_id(ship_battle_initiated);
        let started_at = ship_battle::ship_battle_initiated_started_at(ship_battle_initiated);
        ship_battle::new_ship_battle(
            initiator_id,
            opposing_side_id,
            0, //todo battle status
            ship_battle_util::initiator(),
            started_at,
            ctx
        )
    }
}
