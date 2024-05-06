#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::skill_process_complete_creation_logic {
    use sui::clock::{Self, Clock};
    use sui::tx_context::TxContext;
    use infinite_sea_common::experience_table::ExperienceTable;
    use infinite_sea_common::item_creation::{Self, ItemCreation};
    use infinite_sea_common::item_id;
    use infinite_sea_common::item_id_quantity_pair;

    use infinite_sea::experience_table_util;
    use infinite_sea::player::Player;
    use infinite_sea::player_properties;
    use infinite_sea::skill_process;
    use infinite_sea::skill_process_util;

    // use infinite_sea::skill_process_mutex::{Self, SkillProcessMutex};
    // use infinite_sea::skill_process_mutex_aggregate;
    friend infinite_sea::skill_process_aggregate;

    const EProcessNotStarted: u64 = 10;
    //const EInvalidPlayerId: u64 = 11;
    //const EIncorrectSkillType: u64 = 12;
    //const ENotEnoughEnergy: u64 = 13;
    const EStillInProgress: u64 = 14;
    //const EIncorrectItemId: u64 = 22;
    // const EInvalidMutexPlayerId: u64 = 23;
    //const ELowerThanRequiredLevel: u64 = 24;
    //const ESenderHasNoPermission: u64 = 32;

    public(friend) fun verify(
        // skill_process_mutex: &mut SkillProcessMutex,
        player: &mut Player,
        item_creation: &ItemCreation,
        experience_table: &ExperienceTable,
        clock: &Clock,
        skill_process: &skill_process::SkillProcess,
        ctx: &TxContext,
    ): skill_process::CreationProcessCompleted {
        let (player_id, skill_type, item_id) = skill_process_util::assert_ids_are_consistent_for_completing_creation(
            player, item_creation, skill_process
        );
        assert!(item_id != item_id::unused_item() && !skill_process::completed(skill_process), EProcessNotStarted);
        // assert!(skill_process_mutex::player_id(skill_process_mutex) == player_id, EInvalidMutexPlayerId);

        let started_at = skill_process::started_at(skill_process);
        let creation_time = skill_process::creation_time(skill_process);
        let ended_at = clock::timestamp_ms(clock) / 1000;
        assert!(ended_at >= started_at + creation_time, EStillInProgress);

        let successful = true; //todo
        let quantity = item_creation::base_quantity(item_creation);
        let increased_experience = item_creation::base_experience(item_creation);
        let new_level = experience_table_util::calculate_new_level(player, experience_table, increased_experience);
        skill_process::new_creation_process_completed(
            skill_process,
            item_id,
            started_at,
            creation_time,
            ended_at,
            successful,
            quantity,
            increased_experience,
            new_level,
        )
    }

    public(friend) fun mutate(
        creation_process_completed: &skill_process::CreationProcessCompleted,
        // skill_process_mutex: &mut SkillProcessMutex,
        player: &mut Player,
        skill_process: &mut skill_process::SkillProcess,
        ctx: &mut TxContext, // modify the reference to mutable if needed
    ) {
        let item_id = skill_process::creation_process_completed_item_id(creation_process_completed);
        //let started_at = skill_process::creation_process_completed_started_at(creation_process_completed);
        //let creation_time = skill_process::creation_process_completed_creation_time(creation_process_completed);
        let ended_at = skill_process::creation_process_completed_ended_at(creation_process_completed);
        let successful = skill_process::creation_process_completed_successful(creation_process_completed);
        let quantity = skill_process::creation_process_completed_quantity(creation_process_completed);
        let experience = skill_process::creation_process_completed_experience(creation_process_completed);
        let new_level = skill_process::creation_process_completed_new_level(creation_process_completed);
        let skill_process_id = skill_process::skill_process_id(skill_process);
        // let skill_type = skill_process_id::skill_type(&skill_process_id);

        // skill_process_mutex_aggregate::unlock(skill_process_mutex, skill_type, ctx);

        skill_process::set_completed(skill_process, true);
        skill_process::set_ended_at(skill_process, ended_at);

        if (successful) {
            let items = vector[item_id_quantity_pair::new(item_id, quantity)];
            player_properties::increase_experience_and_inventory_and_set_level(player, experience, items, new_level);
        };
    }
}
