module infinite_sea::roster_delete_logic {
    use infinite_sea::roster;
    use sui::tx_context::TxContext;
    use infinite_sea::roster_util;
    use infinite_sea::ship;

    use std::vector;

    friend infinite_sea::roster_aggregate;

    const ENotDestroyedEnvironmentRoster: u64 = 10;

    public(friend) fun verify(
        roster: &roster::Roster,
        ctx: &TxContext,
    ): roster::RosterDeleted {
        let _ = ctx;
        assert!(roster::environment_owned(roster) && roster_util::is_destroyed(roster), ENotDestroyedEnvironmentRoster);
        // todo more checks??? Can anyone delete?
        roster::new_roster_deleted(
            roster,
        )
    }

    public(friend) fun mutate(
        roster_deleted: &roster::RosterDeleted,
        roster: roster::Roster,
        ctx: &TxContext, // modify the reference to mutable if needed
    ): roster::Roster {
        let roster_id = roster::roster_id(&roster);
        let _ = ctx;
        let _ = roster_id;
        let _ = roster_deleted;
        let ship_ids = roster::ship_ids(&roster);
        let ships = roster::borrow_mut_ships(&mut roster);
        let i = 0;
        let l = vector::length(&ship_ids);
        while (i < l) {
            let ship_id = *vector::borrow(&ship_ids, i);
            let ship = sui::object_table::remove(ships, ship_id);
            ship::drop_ship(ship);
            i = i + 1;
        };

        roster
    }
}
