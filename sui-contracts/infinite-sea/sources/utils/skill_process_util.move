module infinite_sea::skill_process_util {
    use infinite_sea_common::skill_type;

    public fun is_non_mutex_skill(skill_type: u8): bool {
        skill_type == skill_type::farming()
            || skill_type == skill_type::sailing()
            || skill_type == skill_type::township()
    }
}
