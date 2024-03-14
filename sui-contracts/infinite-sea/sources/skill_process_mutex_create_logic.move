#[allow(unused_mut_parameter)]
module infinite_sea::skill_process_mutex_create_logic {
    use infinite_sea::skill_process_mutex;
    use sui::object::ID;
    use sui::tx_context::TxContext;

    friend infinite_sea::skill_process_mutex_aggregate;

    public(friend) fun verify(
        player_id: ID,
        skill_process_mutex_table: &skill_process_mutex::SkillProcessMutexTable,
        ctx: &mut TxContext,
    ): skill_process_mutex::SkillProcessMutexCreated {
        let _ = ctx;
        skill_process_mutex::asset_player_id_not_exists(player_id, skill_process_mutex_table);
        skill_process_mutex::new_skill_process_mutex_created(
            player_id,
        )
    }

    public(friend) fun mutate(
        skill_process_mutex_created: &skill_process_mutex::SkillProcessMutexCreated,
        skill_process_mutex_table: &mut skill_process_mutex::SkillProcessMutexTable,
        ctx: &mut TxContext,
    ): skill_process_mutex::SkillProcessMutex {
        let player_id = skill_process_mutex::skill_process_mutex_created_player_id(skill_process_mutex_created);
        skill_process_mutex::create_skill_process_mutex(
            player_id,
            skill_process_mutex_table,
            ctx,
        )
    }

}
