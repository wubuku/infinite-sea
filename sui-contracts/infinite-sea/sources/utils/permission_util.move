module infinite_sea::permission_util {

    use sui::tx_context;
    use sui::tx_context::TxContext;
    use infinite_sea_common::roster_id;

    use infinite_sea::player::{Self, Player};
    use infinite_sea::roster::{Self, Roster};

    const ESenderIsNotPlayerOwner: u64 = 10;
    const EPlayerIsNotRosterOwner: u64 = 11;

    public fun assert_sender_is_player_owner(player: &Player, ctx: &TxContext) {
        assert!(player::owner(player) == tx_context::sender(ctx), ESenderIsNotPlayerOwner);
    }

    public fun assert_player_is_roster_owner(player: &Player, roster: &Roster) {
        let roster_id = roster::roster_id(roster);
        assert!(roster_id::player_id(&roster_id) == player::id(player), EPlayerIsNotRosterOwner);
    }
}
