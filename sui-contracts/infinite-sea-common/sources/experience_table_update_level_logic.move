#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea_common::experience_table_update_level_logic {
    use std::vector;
    use infinite_sea_common::experience_table;
    use sui::tx_context::{Self, TxContext};
    use infinite_sea_common::experience_level;

    friend infinite_sea_common::experience_table_aggregate;

    const EInvalidLevel: u64 = 10;

    public(friend) fun verify(
        level: u16,
        experience: u32,
        difference: u32,
        experience_table: &experience_table::ExperienceTable,
        ctx: &TxContext,
    ): experience_table::ExperienceLevelUpdated {
        let levels = experience_table::borrow_levels(experience_table);
        assert!((level as u64) < vector::length(levels), EInvalidLevel);
        //let o_xp_level = vector::borrow(levels, (level as u64));
        //assert!(experience_level::level(o_xp_level) == level, EInvalidInternalState); // ignore?
        experience_table::new_experience_level_updated(experience_table, level, experience, difference)
    }

    public(friend) fun mutate(
        experience_level_updated: &experience_table::ExperienceLevelUpdated,
        experience_table: &mut experience_table::ExperienceTable,
        ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        let level = experience_table::experience_level_updated_level(experience_level_updated);
        let experience = experience_table::experience_level_updated_experience(experience_level_updated);
        let difference = experience_table::experience_level_updated_difference(experience_level_updated);
        let xp_level = experience_level::new(level, experience, difference);
        let levels = experience_table::borrow_mut_levels(experience_table);
        vector::remove(levels, (level as u64));
        vector::insert(levels, xp_level, (level as u64));
    }

}
