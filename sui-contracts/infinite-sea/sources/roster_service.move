module infinite_sea::roster_service {
    use sui::clock::Clock;
    use sui::coin::Coin;
    use sui::tx_context;
    use infinite_sea_coin::energy::ENERGY;
    use infinite_sea_common::coin_util;

    use infinite_sea::player::Player;
    use infinite_sea::roster::Roster;
    use infinite_sea::roster_aggregate;

    public entry fun set_sail(
        roster: &mut Roster,
        player: &Player,
        target_coordinates_x: u32,
        target_coordinates_y: u32,
        clock: &Clock,
        energy: Coin<ENERGY>,
        energy_amount: u64,
        ctx: &mut tx_context::TxContext,
    ) {
        let energy_b = coin_util::split_up_and_into_balance(energy, energy_amount, ctx);
        roster_aggregate::set_sail(roster, player, target_coordinates_x, target_coordinates_y, clock, energy_b, ctx);
    }
}
