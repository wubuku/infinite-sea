module infinite_sea::skill_process_service {
    use sui::clock::Clock;
    use sui::coin;
    use sui::coin::Coin;
    use sui::tx_context::Self;
    use infinite_sea_coin::energy::ENERGY;

    use infinite_sea::item_production::ItemProduction;
    use infinite_sea::player::Player;
    use infinite_sea::skill_process::SkillProcess;
    use infinite_sea::skill_process_aggregate;

    public entry fun start_production(
        skill_process: &mut SkillProcess,
        player: &mut Player,
        item_production: &ItemProduction,
        clock: &Clock,
        energy: Coin<ENERGY>,
        ctx: &mut tx_context::TxContext,
    ) {
        let energy_b = coin::into_balance(energy);
        skill_process_aggregate::start_production(
            skill_process,
            player,
            item_production,
            clock,
            energy_b,
            ctx
        )
    }
}
