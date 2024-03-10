#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea_farming::farming_process_start_logic {
    use infinite_sea_farming::farming_item_production::{Self, FarmingItemProduction};
    use infinite_sea_farming::farming_process;
    use sui::clock::Clock;
    use sui::tx_context::{Self, TxContext};
    use infinite_sea_player::player::Player;

    friend infinite_sea_farming::farming_process_aggregate;

    public(friend) fun verify(
        player: &mut Player,
        farming_item_production: &FarmingItemProduction,
        clock: &Clock,
        farming_process: &farming_process::FarmingProcess,
        ctx: &TxContext,
    ): farming_process::FarmingProcessStarted {
        let item_id = farming_item_production::item_id(farming_item_production);
        // todo
        farming_process::new_farming_process_started(
            farming_process,
            item_id,
            0,
        )
    }

    public(friend) fun mutate(
        farming_process_started: &farming_process::FarmingProcessStarted,
        player: &mut Player,
        farming_process: &mut farming_process::FarmingProcess,
        ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        let item_id = farming_process::farming_process_started_item_id(farming_process_started);
        let energy_cost = farming_process::farming_process_started_energy_cost(farming_process_started);
        let player_id = farming_process::player_id(farming_process);
        // todo ...
        //
    }

}
