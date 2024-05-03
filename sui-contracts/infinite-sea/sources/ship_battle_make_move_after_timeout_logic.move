// #[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
// module infinite_sea::ship_battle_make_move_after_timeout_logic {
//     use sui::clock;
//     use infinite_sea::roster::{Self, Roster};
//     use infinite_sea::ship_battle;
//     use sui::clock::Clock;
//     use sui::tx_context::{Self, TxContext};
//     use infinite_sea::ship_battle_util;
//     use infinite_sea::permission_util;
//
//     friend infinite_sea::ship_battle_aggregate;
//
//     const ROUND_TIME_LIMIT: u64 = 10;
//
//     const ERoundNotTimedOutYet: u64 = 100;
//
//     public(friend) fun verify(
//         initiator: &mut Roster,
//         responder: &mut Roster,
//         clock: &Clock,
//         ship_battle: &ship_battle::ShipBattle,
//         ctx: &TxContext,
//     ): ship_battle::ShipBattleMoveMadeAfterTimeout {
//         //permission_util::assert_sender_is_player_owner(player, ctx);
//         ship_battle_util::assert_ids_are_consistent(ship_battle, initiator, responder);
//
//         let now_time = clock::timestamp_ms(clock) / 1000;
//         assert!(ship_battle::round_started_at(ship_battle) + ROUND_TIME_LIMIT > now_time, ERoundNotTimedOutYet);
//
//         ship_battle::new_ship_battle_move_made_after_timeout(ship_battle, now_time)
//     }
//
//     public(friend) fun mutate(
//         ship_battle_move_made_after_timeout: &ship_battle::ShipBattleMoveMadeAfterTimeout,
//         initiator: &mut Roster,
//         responder: &mut Roster,
//         ship_battle: &mut ship_battle::ShipBattle,
//         ctx: &TxContext, // modify the reference to mutable if needed
//     ) {
//         let id = ship_battle::id(ship_battle);
//         // ...
//         //
//     }
//
// }
