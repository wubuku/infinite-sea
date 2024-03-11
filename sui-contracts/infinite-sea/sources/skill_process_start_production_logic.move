#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::skill_process_start_production_logic {
    use sui::clock;
    use sui::clock::Clock;
    use sui::tx_context::TxContext;
    use infinite_sea_common::skill_type_item_id_pair;

    use infinite_sea::item_production::{Self, ItemProduction};
    use infinite_sea::player::Player;
    use infinite_sea::skill_process;

    friend infinite_sea::skill_process_aggregate;

    public(friend) fun verify(
        player: &mut Player,
        item_production: &ItemProduction,
        clock: &Clock,
        skill_process: &skill_process::SkillProcess,
        ctx: &TxContext,
    ): skill_process::ProductionProcessStarted {
        let skill_type_item_id = item_production::item_production_id(item_production);
        let item_id = skill_type_item_id_pair::item_id(&skill_type_item_id);
        // todo
        skill_process::new_production_process_started(
            skill_process,
            item_id,
            0,
            clock::timestamp_ms(clock) / 1000,
            0, //todo
        )
    }

    public(friend) fun mutate(
        production_process_started: &skill_process::ProductionProcessStarted,
        player: &mut Player,
        skill_process: &mut skill_process::SkillProcess,
        ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        let item_id = skill_process::production_process_started_item_id(production_process_started);
        let energy_cost = skill_process::production_process_started_energy_cost(production_process_started);
        let skill_process_id = skill_process::skill_process_id(skill_process);
        // ...
        //
    }
}
