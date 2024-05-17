#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::skill_process_start_production_logic {
    use sui::balance::{Self, Balance};
    use sui::clock::{Self, Clock};
    use sui::tx_context::TxContext;
    use infinite_sea_common::item_id;
    use infinite_sea_common::item_id_quantity_pairs;
    use infinite_sea_common::item_production::{Self, ItemProduction};
    use infinite_sea_common::sorted_vector_util;

    use infinite_sea::player::{Self, Player};
    use infinite_sea::player_properties;
    use infinite_sea::skill_process;
    use infinite_sea::skill_process::production_process_started_started_at;
    use infinite_sea::skill_process_util;

    friend infinite_sea::skill_process_aggregate;

    const EProcessAlreadyStarted: u64 = 10;
    //const EInvalidPlayerId: u64 = 11;
    //const EIncorrectSkillType: u64 = 12;
    const ENotEnoughEnergy: u64 = 13;
    const ELowerThanRequiredLevel: u64 = 14;
    //const EIsMutexSkillType: u64 = 15;
    const ESenderHasNoPermission: u64 = 22;
    const EItemProduceIndividuals: u64 = 24;

    public(friend) fun verify(
        batch_size: u32,
        player: &mut Player,
        item_production: &ItemProduction,
        clock: &Clock,
        energy: &Balance<infinite_sea_coin::energy::ENERGY>,
        skill_process: &skill_process::SkillProcess,
        ctx: &TxContext,
    ): skill_process::ProductionProcessStarted {
        assert!(sui::tx_context::sender(ctx) == player::owner(player), ESenderHasNoPermission);
        assert!(
            skill_process::item_id(skill_process) == item_id::unused_item() || skill_process::completed(skill_process),
            EProcessAlreadyStarted
        );
        let (_player_id, skill_type, item_id) = skill_process_util::assert_ids_are_consistent_for_starting_production(
            player, item_production, skill_process
        );
        //assert!(skill_process_util::is_non_mutex_skill(skill_type), EIsMutexSkillType);
        assert!(!item_id::should_produce_individuals(item_id), EItemProduceIndividuals);

        let requirements_level = item_production::requirements_level(item_production);
        assert!(player::level(player) >= requirements_level, ELowerThanRequiredLevel);

        let base_creation_time = item_production::base_creation_time(item_production);
        let energy_cost = balance::value(energy);
        assert!(energy_cost >= item_production::energy_cost(item_production) * (batch_size as u64), ENotEnoughEnergy);
        let creation_time = base_creation_time * (batch_size as u64); // todo level-based or XXX-based creation time calculation?
        let production_materials = sorted_vector_util::item_id_quantity_pairs_multiply(
            item_id_quantity_pairs::borrow_items(&item_production::production_materials(item_production)), batch_size);
        skill_process::new_production_process_started(
            skill_process,
            batch_size,
            item_id,
            energy_cost,
            clock::timestamp_ms(clock) / 1000,
            creation_time,
            item_id_quantity_pairs::new_by_vector(production_materials),
        )
    }


    public(friend) fun mutate(
        production_process_started: &skill_process::ProductionProcessStarted,
        energy: Balance<infinite_sea_coin::energy::ENERGY>,
        player: &mut Player,
        skill_process: &mut skill_process::SkillProcess,
        ctx: &mut TxContext, // modify the reference to mutable if needed
    ) {
        let item_id = skill_process::production_process_started_item_id(production_process_started);
        let started_at = production_process_started_started_at(production_process_started);
        let creation_time = skill_process::production_process_started_creation_time(production_process_started);
        //let skill_process_id = skill_process::skill_process_id(skill_process);
        //let energy_cost = skill_process::production_process_started_energy_cost(production_process_started);
        let production_materials = skill_process::production_process_started_production_materials(
            production_process_started
        );
        let batch_size = skill_process::production_process_started_batch_size(production_process_started);
        skill_process::set_item_id(skill_process, item_id);
        skill_process::set_started_at(skill_process, started_at);
        skill_process::set_creation_time(skill_process, creation_time);
        skill_process::set_completed(skill_process, false);
        skill_process::set_ended_at(skill_process, 0);
        skill_process::set_batch_size(skill_process, batch_size);

        let energy_vault = skill_process::borrow_mut_energy_vault(skill_process);
        balance::join(energy_vault, energy);

        player_properties::deduct_inventory(player, item_id_quantity_pairs::items(&production_materials));
    }
}
