#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::skill_process_complete_production_logic {
    use sui::clock;
    use sui::clock::Clock;
    use sui::tx_context::TxContext;
    use infinite_sea_common::experience_table::ExperienceTable;
    use infinite_sea_common::item_id;
    use infinite_sea_common::skill_type_item_id_pair;
    use infinite_sea_common::skill_type_player_id_pair;

    use infinite_sea::item_production::{Self, ItemProduction};
    use infinite_sea::player::Player;
    use infinite_sea::skill_process;

    friend infinite_sea::skill_process_aggregate;

    const EProcessNotStarted: u64 = 10;
    const EIncorrectItemId: u64 = 11;
    const EIncorrectSkillType: u64 = 12;

    public(friend) fun verify(
        player: &mut Player,
        item_production: &ItemProduction,
        experience_table: &ExperienceTable,
        clock: &Clock,
        skill_process: &skill_process::SkillProcess,
        ctx: &TxContext,
    ): skill_process::ProductionProcessCompleted {
        let item_id = skill_process::item_id(skill_process);
        assert!(item_id != item_id::unused_item() && !skill_process::completed(skill_process), EProcessNotStarted);

        let item_production_id = item_production::item_production_id(item_production);
        assert!(item_id == skill_type_item_id_pair::item_id(&item_production_id), EIncorrectItemId);
        let skill_type = skill_type_item_id_pair::skill_type(&item_production_id);
        let skill_process_id = skill_process::skill_process_id(skill_process);
        assert!(skill_type == skill_type_player_id_pair::skill_type(&skill_process_id), EIncorrectSkillType);

        let started_at = skill_process::started_at(skill_process);
        //assert!(started_at != 0, 0);
        let creation_time = skill_process::creation_time(skill_process);
        let ended_at = clock::timestamp_ms(clock);
        skill_process::new_production_process_completed(
            skill_process,
            item_id,
            started_at,
            creation_time,
            ended_at,
            true, //todo
        )
    }

    public(friend) fun mutate(
        production_process_completed: &skill_process::ProductionProcessCompleted,
        player: &mut Player,
        skill_process: &mut skill_process::SkillProcess,
        ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        let item_id = skill_process::production_process_completed_item_id(production_process_completed);
        let started_at = skill_process::production_process_completed_started_at(production_process_completed);
        let creation_time = skill_process::production_process_completed_creation_time(production_process_completed);
        let ended_at = skill_process::production_process_completed_ended_at(production_process_completed);
        let successful = skill_process::production_process_completed_successful(production_process_completed);
        let skill_process_id = skill_process::skill_process_id(skill_process);
        // ...
        //
    }
}
