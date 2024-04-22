// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

module infinite_sea_common::experience_table {
    use infinite_sea_common::experience_level::ExperienceLevel;
    use sui::event;
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::TxContext;

    struct EXPERIENCE_TABLE has drop {}

    friend infinite_sea_common::experience_table_add_level_logic;
    friend infinite_sea_common::experience_table_update_level_logic;
    friend infinite_sea_common::experience_table_aggregate;

    #[allow(unused_const)]
    const EDataTooLong: u64 = 102;
    #[allow(unused_const)]
    const EInappropriateVersion: u64 = 103;

    fun init(otw: EXPERIENCE_TABLE, ctx: &mut TxContext) {
        let experience_table = new_experience_table(
            otw,
            ctx,
        );
        event::emit(new_init_experience_table_event(&experience_table));
        share_object(experience_table);
    }

    struct ExperienceTable has key {
        id: UID,
        version: u64,
        levels: vector<ExperienceLevel>,
    }

    public fun id(experience_table: &ExperienceTable): object::ID {
        object::uid_to_inner(&experience_table.id)
    }

    public fun version(experience_table: &ExperienceTable): u64 {
        experience_table.version
    }

    public fun borrow_levels(experience_table: &ExperienceTable): &vector<ExperienceLevel> {
        &experience_table.levels
    }

    public(friend) fun borrow_mut_levels(experience_table: &mut ExperienceTable): &mut vector<ExperienceLevel> {
        &mut experience_table.levels
    }

    public fun levels(experience_table: &ExperienceTable): vector<ExperienceLevel> {
        experience_table.levels
    }

    public(friend) fun set_levels(experience_table: &mut ExperienceTable, levels: vector<ExperienceLevel>) {
        experience_table.levels = levels;
    }

    public(friend) fun new_experience_table(
        _witness: EXPERIENCE_TABLE,
        ctx: &mut TxContext,
    ): ExperienceTable {
        ExperienceTable {
            id: object::new(ctx),
            version: 0,
            levels: std::vector::empty(),
        }
    }

    struct InitExperienceTableEvent has copy, drop {
        id: object::ID,
    }

    public fun init_experience_table_event_id(init_experience_table_event: &InitExperienceTableEvent): object::ID {
        init_experience_table_event.id
    }

    public(friend) fun new_init_experience_table_event(
        experience_table: &ExperienceTable,
    ): InitExperienceTableEvent {
        InitExperienceTableEvent {
            id: id(experience_table),
        }
    }

    struct ExperienceLevelAdded has copy, drop {
        id: object::ID,
        version: u64,
        level: u16,
        experience: u32,
        difference: u32,
    }

    public fun experience_level_added_id(experience_level_added: &ExperienceLevelAdded): object::ID {
        experience_level_added.id
    }

    public fun experience_level_added_level(experience_level_added: &ExperienceLevelAdded): u16 {
        experience_level_added.level
    }

    public fun experience_level_added_experience(experience_level_added: &ExperienceLevelAdded): u32 {
        experience_level_added.experience
    }

    public fun experience_level_added_difference(experience_level_added: &ExperienceLevelAdded): u32 {
        experience_level_added.difference
    }

    public(friend) fun new_experience_level_added(
        experience_table: &ExperienceTable,
        level: u16,
        experience: u32,
        difference: u32,
    ): ExperienceLevelAdded {
        ExperienceLevelAdded {
            id: id(experience_table),
            version: version(experience_table),
            level,
            experience,
            difference,
        }
    }

    struct ExperienceLevelUpdated has copy, drop {
        id: object::ID,
        version: u64,
        level: u16,
        experience: u32,
        difference: u32,
    }

    public fun experience_level_updated_id(experience_level_updated: &ExperienceLevelUpdated): object::ID {
        experience_level_updated.id
    }

    public fun experience_level_updated_level(experience_level_updated: &ExperienceLevelUpdated): u16 {
        experience_level_updated.level
    }

    public fun experience_level_updated_experience(experience_level_updated: &ExperienceLevelUpdated): u32 {
        experience_level_updated.experience
    }

    public fun experience_level_updated_difference(experience_level_updated: &ExperienceLevelUpdated): u32 {
        experience_level_updated.difference
    }

    public(friend) fun new_experience_level_updated(
        experience_table: &ExperienceTable,
        level: u16,
        experience: u32,
        difference: u32,
    ): ExperienceLevelUpdated {
        ExperienceLevelUpdated {
            id: id(experience_table),
            version: version(experience_table),
            level,
            experience,
            difference,
        }
    }


    #[lint_allow(share_owned)]
    public(friend) fun share_object(experience_table: ExperienceTable) {
        assert!(experience_table.version == 0, EInappropriateVersion);
        transfer::share_object(experience_table);
    }

    public(friend) fun update_object_version(experience_table: &mut ExperienceTable) {
        experience_table.version = experience_table.version + 1;
        //assert!(experience_table.version != 0, EInappropriateVersion);
    }

    public(friend) fun drop_experience_table(experience_table: ExperienceTable) {
        let ExperienceTable {
            id,
            version: _version,
            levels: _levels,
        } = experience_table;
        object::delete(id);
    }

    public(friend) fun emit_experience_level_added(experience_level_added: ExperienceLevelAdded) {
        event::emit(experience_level_added);
    }

    public(friend) fun emit_experience_level_updated(experience_level_updated: ExperienceLevelUpdated) {
        event::emit(experience_level_updated);
    }

}
