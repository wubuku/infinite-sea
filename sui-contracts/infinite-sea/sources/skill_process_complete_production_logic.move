#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::skill_process_complete_production_logic {
    use std::vector;

    use sui::clock;
    use sui::clock::Clock;
    use sui::tx_context::TxContext;
    use infinite_sea::experience_table_util;
    use infinite_sea_common::experience_level;
    use infinite_sea_common::experience_table;
    use infinite_sea_common::experience_table::ExperienceTable;
    use infinite_sea_common::item_id;
    use infinite_sea_common::production_material;
    use infinite_sea_common::skill_type_item_id_pair;
    use infinite_sea_common::skill_type_player_id_pair;

    use infinite_sea_common::item_production::{Self, ItemProduction};
    use infinite_sea::player;
    use infinite_sea::player::Player;
    use infinite_sea::player_aggregate;
    use infinite_sea::skill_process;

    friend infinite_sea::skill_process_aggregate;

    const EProcessNotStarted: u64 = 10;
    const EInvalidPlayerId: u64 = 11;
    const EIncorrectSkillType: u64 = 12;
    //const ENotEnoughEnergy: u64 = 13;
    const EStillInProgress: u64 = 14;
    const EIncorrectItemId: u64 = 22;
    //const ELowerThanRequiredLevel: u64 = 24;
    //const ESenderHasNoPermission: u64 = 32;

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
        let player_id = infinite_sea_common::skill_type_player_id_pair::player_id(&skill_process_id);
        assert!(player::id(player) == player_id, EInvalidPlayerId);

        let started_at = skill_process::started_at(skill_process);
        let creation_time = skill_process::creation_time(skill_process);
        let ended_at = clock::timestamp_ms(clock) / 1000;
        assert!(ended_at >= started_at + creation_time, EStillInProgress);

        let successful = true; //todo
        let quantity = item_production::base_quantity(item_production);
        let added_experience = item_production::base_experience(item_production);
        let new_level = experience_table_util::calculate_new_level(player, experience_table, added_experience);
        skill_process::new_production_process_completed(
            skill_process,
            item_id,
            started_at,
            creation_time,
            ended_at,
            successful,
            quantity,
            added_experience,
            new_level,
        )
    }

    public(friend) fun mutate(
        production_process_completed: &skill_process::ProductionProcessCompleted,
        player: &mut Player,
        skill_process: &mut skill_process::SkillProcess,
        ctx: &mut TxContext, // modify the reference to mutable if needed
    ) {
        let item_id = skill_process::production_process_completed_item_id(production_process_completed);
        //let started_at = skill_process::production_process_completed_started_at(production_process_completed);
        //let creation_time = skill_process::production_process_completed_creation_time(production_process_completed);
        let ended_at = skill_process::production_process_completed_ended_at(production_process_completed);
        let successful = skill_process::production_process_completed_successful(production_process_completed);
        //let skill_process_id = skill_process::skill_process_id(skill_process);
        let quantity = skill_process::production_process_completed_quantity(production_process_completed);
        let experience = skill_process::production_process_completed_experience(production_process_completed);
        let new_level = skill_process::production_process_completed_new_level(production_process_completed);

        //skill_process::set_item_id(skill_process, item_id);
        //skill_process::set_started_at(skill_process, started_at);
        skill_process::set_completed(skill_process, true);
        skill_process::set_ended_at(skill_process, ended_at);

        if (successful) {
            let items = vector[production_material::new(item_id, quantity)];
            player_aggregate::increase_experience_and_items(player, experience, items, new_level, ctx);
        };
    }
}
