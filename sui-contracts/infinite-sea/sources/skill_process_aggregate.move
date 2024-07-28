// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

module infinite_sea::skill_process_aggregate {
    use infinite_sea::player::Player;
    use infinite_sea::roster::Roster;
    use infinite_sea::skill_process;
    use infinite_sea::skill_process_complete_creation_logic;
    use infinite_sea::skill_process_complete_production_logic;
    use infinite_sea::skill_process_complete_ship_production_logic;
    use infinite_sea::skill_process_create_logic;
    use infinite_sea::skill_process_start_creation_logic;
    use infinite_sea::skill_process_start_production_logic;
    use infinite_sea::skill_process_start_ship_production_logic;
    use infinite_sea_coin::energy::ENERGY;
    use infinite_sea_common::experience_table::ExperienceTable;
    use infinite_sea_common::item_creation::ItemCreation;
    use infinite_sea_common::item_id_quantity_pairs::{Self, ItemIdQuantityPairs};
    use infinite_sea_common::item_production::ItemProduction;
    use infinite_sea_common::skill_process_id::{Self, SkillProcessId};
    use sui::balance::Balance;
    use sui::clock::Clock;
    use sui::object::ID;
    use sui::tx_context;

    friend infinite_sea::player_claim_island_logic;
    friend infinite_sea::player_nft_holder_claim_island_logic;
    friend infinite_sea::skill_process_service;
    friend infinite_sea::roster_service;
    friend infinite_sea::ship_battle_service;

    public entry fun create(
        skill_process_id_skill_type: u8,
        skill_process_id_player_id: ID,
        skill_process_id_sequence_number: u8,
        player: &Player,
        skill_process_table: &mut skill_process::SkillProcessTable,
        ctx: &mut tx_context::TxContext,
    ) {
        let skill_process_id: SkillProcessId = skill_process_id::new(
            skill_process_id_skill_type,
            skill_process_id_player_id,
            skill_process_id_sequence_number,
        );

        let skill_process_created = skill_process_create_logic::verify(
            skill_process_id,
            player,
            skill_process_table,
            ctx,
        );
        let skill_process = skill_process_create_logic::mutate(
            &skill_process_created,
            skill_process_table,
            ctx,
        );
        skill_process::set_skill_process_created_id(&mut skill_process_created, skill_process::id(&skill_process));
        skill_process::share_object(skill_process);
        skill_process::emit_skill_process_created(skill_process_created);
    }

    public fun start_production(
        skill_process: &mut skill_process::SkillProcess,
        batch_size: u32,
        player: &mut Player,
        item_production: &ItemProduction,
        clock: &Clock,
        energy: Balance<ENERGY>,
        ctx: &mut tx_context::TxContext,
    ) {
        let production_process_started = skill_process_start_production_logic::verify(
            batch_size,
            player,
            item_production,
            clock,
            &energy,
            skill_process,
            ctx,
        );
        skill_process_start_production_logic::mutate(
            &production_process_started,
            energy,
            player,
            skill_process,
            ctx,
        );
        skill_process::update_object_version(skill_process);
        skill_process::emit_production_process_started(production_process_started);
    }

    public entry fun complete_production(
        skill_process: &mut skill_process::SkillProcess,
        player: &mut Player,
        item_production: &ItemProduction,
        experience_table: &ExperienceTable,
        clock: &Clock,
        ctx: &mut tx_context::TxContext,
    ) {
        let production_process_completed = skill_process_complete_production_logic::verify(
            player,
            item_production,
            experience_table,
            clock,
            skill_process,
            ctx,
        );
        skill_process_complete_production_logic::mutate(
            &production_process_completed,
            player,
            skill_process,
            ctx,
        );
        skill_process::update_object_version(skill_process);
        skill_process::emit_production_process_completed(production_process_completed);
    }

    public fun start_ship_production(
        skill_process: &mut skill_process::SkillProcess,
        production_materials_item_id_list: vector<u32>,
        production_materials_item_quantity_list: vector<u32>,
        player: &mut Player,
        item_production: &ItemProduction,
        clock: &Clock,
        energy: Balance<ENERGY>,
        ctx: &mut tx_context::TxContext,
    ) {
        let production_materials: ItemIdQuantityPairs = item_id_quantity_pairs::new(
            production_materials_item_id_list,
            production_materials_item_quantity_list,
        );
        let ship_production_process_started = skill_process_start_ship_production_logic::verify(
            production_materials,
            player,
            item_production,
            clock,
            &energy,
            skill_process,
            ctx,
        );
        skill_process_start_ship_production_logic::mutate(
            &ship_production_process_started,
            energy,
            player,
            skill_process,
            ctx,
        );
        skill_process::update_object_version(skill_process);
        skill_process::emit_ship_production_process_started(ship_production_process_started);
    }

    public entry fun complete_ship_production(
        skill_process: &mut skill_process::SkillProcess,
        unassigned_ships: &mut Roster,
        player: &mut Player,
        item_production: &ItemProduction,
        experience_table: &ExperienceTable,
        clock: &Clock,
        ctx: &mut tx_context::TxContext,
    ) {
        let ship_production_process_completed = skill_process_complete_ship_production_logic::verify(
            unassigned_ships,
            player,
            item_production,
            experience_table,
            clock,
            skill_process,
            ctx,
        );
        skill_process_complete_ship_production_logic::mutate(
            &ship_production_process_completed,
            unassigned_ships,
            player,
            skill_process,
            ctx,
        );
        skill_process::update_object_version(skill_process);
        skill_process::emit_ship_production_process_completed(ship_production_process_completed);
    }

    public fun start_creation(
        skill_process: &mut skill_process::SkillProcess,
        batch_size: u32,
        player: &mut Player,
        item_creation: &ItemCreation,
        clock: &Clock,
        energy: Balance<ENERGY>,
        ctx: &mut tx_context::TxContext,
    ) {
        let creation_process_started = skill_process_start_creation_logic::verify(
            batch_size,
            player,
            item_creation,
            clock,
            &energy,
            skill_process,
            ctx,
        );
        skill_process_start_creation_logic::mutate(
            &creation_process_started,
            energy,
            player,
            skill_process,
            ctx,
        );
        skill_process::update_object_version(skill_process);
        skill_process::emit_creation_process_started(creation_process_started);
    }

    public entry fun complete_creation(
        skill_process: &mut skill_process::SkillProcess,
        player: &mut Player,
        item_creation: &ItemCreation,
        experience_table: &ExperienceTable,
        clock: &Clock,
        ctx: &mut tx_context::TxContext,
    ) {
        let creation_process_completed = skill_process_complete_creation_logic::verify(
            player,
            item_creation,
            experience_table,
            clock,
            skill_process,
            ctx,
        );
        skill_process_complete_creation_logic::mutate(
            &creation_process_completed,
            player,
            skill_process,
            ctx,
        );
        skill_process::update_object_version(skill_process);
        skill_process::emit_creation_process_completed(creation_process_completed);
    }

}
