module infinite_sea_common::experience_table_util {

    use std::vector;

    use infinite_sea_common::experience_level;
    use infinite_sea_common::experience_table::{Self, ExperienceTable};

    const EExperienceTableNotInitialized: u64 = 15;

    public fun calculate_new_level(
        old_level: u16, // = player::level(player);
        old_experience: u32, // = player::experience(player);
        experience_table: &ExperienceTable,
        increased_experience: u32,
    ): u16 {
        let new_experience = old_experience + increased_experience;
        let new_level = old_level;
        let xp_levels = experience_table::borrow_levels(experience_table);
        let xp_levels_len = vector::length(xp_levels);
        assert!(xp_levels_len > 1, EExperienceTableNotInitialized);
        let max_level = xp_levels_len - 1;
        if (max_level > (old_level as u64)) {
            let i = (old_level as u64) + 1;
            while (i <= max_level) {
                let xp_level = vector::borrow(xp_levels, i);
                if (new_experience >= experience_level::experience(xp_level)) {
                    new_level = experience_level::level(xp_level);
                } else {
                    break
                };
                i = i + 1;
            };
        };
        new_level
    }
}
