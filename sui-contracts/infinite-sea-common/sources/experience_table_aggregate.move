// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

module infinite_sea_common::experience_table_aggregate {
    use infinite_sea_common::experience_table;
    use infinite_sea_common::experience_table_add_level_logic;
    use infinite_sea_common::experience_table_update_level_logic;
    use sui::tx_context;

    const ENotPublisher: u64 = 50;

    public entry fun add_level(
        experience_table: &mut experience_table::ExperienceTable,
        publisher: &sui::package::Publisher,
        level: u16,
        experience: u32,
        difference: u32,
        ctx: &mut tx_context::TxContext,
    ) {
        assert!(sui::package::from_package<experience_table::ExperienceTable>(publisher), ENotPublisher);
        let experience_level_added = experience_table_add_level_logic::verify(
            level,
            experience,
            difference,
            experience_table,
            ctx,
        );
        experience_table_add_level_logic::mutate(
            &experience_level_added,
            experience_table,
            ctx,
        );
        experience_table::update_object_version(experience_table);
        experience_table::emit_experience_level_added(experience_level_added);
    }

    public entry fun update_level(
        experience_table: &mut experience_table::ExperienceTable,
        publisher: &sui::package::Publisher,
        level: u16,
        experience: u32,
        difference: u32,
        ctx: &mut tx_context::TxContext,
    ) {
        assert!(sui::package::from_package<experience_table::ExperienceTable>(publisher), ENotPublisher);
        let experience_level_updated = experience_table_update_level_logic::verify(
            level,
            experience,
            difference,
            experience_table,
            ctx,
        );
        experience_table_update_level_logic::mutate(
            &experience_level_updated,
            experience_table,
            ctx,
        );
        experience_table::update_object_version(experience_table);
        experience_table::emit_experience_level_updated(experience_level_updated);
    }

}
