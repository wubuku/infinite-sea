#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::skill_process_mutex_unlock_logic {
    use std::option;

    use sui::tx_context::TxContext;

    use infinite_sea::skill_process_mutex;
    use infinite_sea::skill_process_util;

    friend infinite_sea::skill_process_mutex_aggregate;

    const ENotLocked: u64 = 10;
    const EIncorrectSkillType: u64 = 12;
    const EIsNonMutexSkillType: u64 = 15;

    public(friend) fun verify(
        skill_type: u8,
        skill_process_mutex: &skill_process_mutex::SkillProcessMutex,
        ctx: &TxContext,
    ): skill_process_mutex::SkillProcessMutexUnlocked {
        assert!(!skill_process_util::is_non_mutex_skill(skill_type), EIsNonMutexSkillType);
        let active_skill_type = skill_process_mutex::active_skill_type(skill_process_mutex);
        assert!(option::is_some(&active_skill_type), ENotLocked);
        assert!(skill_type == option::extract(&mut active_skill_type), EIncorrectSkillType);
        skill_process_mutex::new_skill_process_mutex_unlocked(skill_process_mutex, skill_type)
    }

    public(friend) fun mutate(
        skill_process_mutex_unlocked: &skill_process_mutex::SkillProcessMutexUnlocked,
        skill_process_mutex: &mut skill_process_mutex::SkillProcessMutex,
        ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        //let skill_type = skill_process_mutex::skill_process_mutex_unlocked_skill_type(skill_process_mutex_unlocked);
        //let player_id = skill_process_mutex::player_id(skill_process_mutex);
        skill_process_mutex::set_active_skill_type(skill_process_mutex, option::none());
    }
}
