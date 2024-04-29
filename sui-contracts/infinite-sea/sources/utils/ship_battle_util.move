module infinite_sea::ship_battle_util {
    use std::option;

    use infinite_sea::permission_util;
    use infinite_sea::player::Player;
    use infinite_sea::roster;
    use infinite_sea::roster::Roster;
    use infinite_sea::ship_battle;
    use infinite_sea::ship_battle::ShipBattle;
    use infinite_sea::ship_battle_util;

    const EInitiatorBattleIdMismatch: u64 = 10;
    const EResponderBattleIdMismatch: u64 = 11;
    const EInitiatorIdMismatch: u64 = 12;
    const EResponderIdMismatch: u64 = 13;

    public fun initiator(): u8 {
        1
    }

    public fun responder(): u8 {
        2
    }

    public fun assert_palyer_is_current_round_mover(player: &Player, ship_battle: &ShipBattle,
                                                    initiator: &Roster, responder: &Roster
    ) {
        ship_battle_util::assert_ids_are_consistent(ship_battle, initiator, responder);

        let round_mover = ship_battle::round_mover(ship_battle);
        if (round_mover == ship_battle_util::initiator()) {
            permission_util::assert_player_is_roster_owner(player, initiator);
        } else {
            permission_util::assert_player_is_roster_owner(player, responder);
        };
    }

    public fun assert_ids_are_consistent(ship_battle: &ShipBattle, initiator: &Roster, responder: &Roster) {
        let battle_id = ship_battle::id(ship_battle);
        let i_battle_id = roster::ship_battle_id(initiator);
        assert!(battle_id == *option::borrow(&i_battle_id), EInitiatorBattleIdMismatch);
        let r_battle_id = roster::ship_battle_id(responder);
        assert!(battle_id == *option::borrow(&r_battle_id), EResponderBattleIdMismatch);

        let initiator_id = ship_battle::initiator(ship_battle);
        assert!(initiator_id == roster::id(initiator), EInitiatorIdMismatch);

        let responder_id = ship_battle::responder(ship_battle);
        assert!(responder_id == roster::id(responder), EResponderIdMismatch);
    }
}
