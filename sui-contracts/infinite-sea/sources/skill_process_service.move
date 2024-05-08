module infinite_sea::skill_process_service {
    use sui::balance::Balance;
    use sui::clock::Clock;
    use sui::coin::{Self, Coin};
    use sui::transfer;
    use sui::tx_context;
    use sui::tx_context::TxContext;
    use infinite_sea_coin::energy::ENERGY;
    use infinite_sea_common::item_production;
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
        let energy_cost = item_production::energy_cost(item_production);
        let energy_b = split_up_and_into_balance(energy, energy_cost, ctx);
        skill_process_aggregate::start_production(
            skill_process,
            player,
            item_production,
            clock,
            energy_b,
            ctx
        )
    }

    #[lint_allow(self_transfer)]
    fun split_up_and_into_balance<T>(coin: Coin<T>, amount: u64, ctx: &mut TxContext): Balance<T> {
        if (coin::value(&coin) == amount) {
            coin::into_balance(coin)
        } else {
            let s = coin::into_balance(coin::split(&mut coin, amount, ctx));
            transfer::public_transfer(coin, tx_context::sender(ctx));
            s
        }
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
