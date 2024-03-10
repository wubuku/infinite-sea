#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea_common::experience_table_add_level_logic {
    use std::vector;

    use sui::tx_context::TxContext;

    use infinite_sea_common::experience_level;
    use infinite_sea_common::experience_table;

    friend infinite_sea_common::experience_table_aggregate;

    const ELevelNotEqualToIndex: u64 = 10;

    public(friend) fun verify(
        level: u16,
        experience: u32,
        difference: u32,
        experience_table: &experience_table::ExperienceTable,
        ctx: &TxContext,
    ): experience_table::ExperienceLevelAdded {
        let levels = experience_table::borrow_levels(experience_table);
        assert!((level as u64) == vector::length(levels), ELevelNotEqualToIndex);
        experience_table::new_experience_level_added(experience_table, level, experience, difference)
    }

    public(friend) fun mutate(
        experience_level_added: &experience_table::ExperienceLevelAdded,
        experience_table: &mut experience_table::ExperienceTable,
        ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        let level = experience_table::experience_level_added_level(experience_level_added);
        let experience = experience_table::experience_level_added_experience(experience_level_added);
        let difference = experience_table::experience_level_added_difference(experience_level_added);
        let xp_level = experience_level::new(level, experience, difference);
        let levels = experience_table::borrow_mut_levels(experience_table);
        vector::push_back(levels, xp_level);
    }
}
