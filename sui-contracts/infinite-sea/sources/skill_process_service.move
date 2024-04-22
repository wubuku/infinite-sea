module infinite_sea::skill_process_service {
    use sui::clock::Clock;
    use sui::coin::{Self, Coin};
    use sui::tx_context;
    use infinite_sea_coin::energy::ENERGY;
    use infinite_sea_common::item_production::ItemProduction;

    use infinite_sea::player::Player;
    use infinite_sea::skill_process::SkillProcess;
    use infinite_sea::skill_process_aggregate;

    // use infinite_sea::skill_process_mutex::SkillProcessMutex;

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

    // public entry fun start_mutex_creation(
    //     skill_process: &mut SkillProcess,
    //     skill_process_mutex: &mut SkillProcessMutex,
    //     player: &mut Player,
    //     item_creation: &ItemCreation,
    //     clock: &Clock,
    //     energy: Coin<ENERGY>,
    //     ctx: &mut tx_context::TxContext,
    // ) {
    //     let energy_b = coin::into_balance(energy);
    //     skill_process_aggregate::start_mutex_creation(
    //         skill_process,
    //         skill_process_mutex,
    //         player,
    //         item_creation,
    //         clock,
    //         energy_b,
    //         ctx
    //     )
    // }
}
