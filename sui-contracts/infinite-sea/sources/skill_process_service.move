module infinite_sea::skill_process_service {
    use sui::clock::Clock;
    use sui::coin::Coin;
    use sui::tx_context;
    use infinite_sea_coin::energy::ENERGY;
    use infinite_sea_common::coin_util;
    use infinite_sea_common::item_creation;
    use infinite_sea_common::item_creation::ItemCreation;
    use infinite_sea_common::item_production;
    use infinite_sea_common::item_production::ItemProduction;

    use infinite_sea::player::Player;
    use infinite_sea::skill_process::SkillProcess;
    use infinite_sea::skill_process_aggregate;

    public entry fun start_creation(
        skill_process: &mut SkillProcess,
        batch_size: u32,
        player: &mut Player,
        item_creation: &ItemCreation,
        clock: &Clock,
        energy: Coin<ENERGY>,
        ctx: &mut tx_context::TxContext,
    ) {
        let energy_cost = item_creation::energy_cost(item_creation) * (batch_size as u64);
        let energy_b = coin_util::split_up_and_into_balance(energy, energy_cost, ctx);
        skill_process_aggregate::start_creation(
            skill_process,
            batch_size,
            player,
            item_creation,
            clock,
            energy_b,
            ctx
        )
    }

    public entry fun start_production(
        skill_process: &mut SkillProcess,
        batch_size: u32,
        player: &mut Player,
        item_production: &ItemProduction,
        clock: &Clock,
        energy: Coin<ENERGY>,
        ctx: &mut tx_context::TxContext,
    ) {
        let energy_cost = item_production::energy_cost(item_production) * (batch_size as u64);
        let energy_b = coin_util::split_up_and_into_balance(energy, energy_cost, ctx);
        skill_process_aggregate::start_production(
            skill_process,
            batch_size,
            player,
            item_production,
            clock,
            energy_b,
            ctx
        )
    }

    public entry fun start_ship_production(
        skill_process: &mut SkillProcess,
        production_materials_item_id_list: vector<u32>,
        production_materials_item_quantity_list: vector<u32>,
        player: &mut Player,
        item_production: &ItemProduction,
        clock: &Clock,
        energy: Coin<ENERGY>,
        ctx: &mut tx_context::TxContext,
    ) {
        let energy_cost = item_production::energy_cost(item_production);
        let energy_b = coin_util::split_up_and_into_balance(energy, energy_cost, ctx);
        skill_process_aggregate::start_ship_production(
            skill_process,
            production_materials_item_id_list,
            production_materials_item_quantity_list,
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
