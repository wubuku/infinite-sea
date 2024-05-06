#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::skill_process_start_ship_production_logic {
    use std::option;
    use std::vector;

    use sui::balance;
    use sui::balance::Balance;
    use sui::clock;
    use sui::clock::Clock;
    use sui::tx_context::TxContext;
    use infinite_sea_coin::energy::ENERGY;
    use infinite_sea_common::item_id;
    use infinite_sea_common::item_id_quantity_pair;
    use infinite_sea_common::item_id_quantity_pairs;
    use infinite_sea_common::item_id_quantity_pairs::ItemIdQuantityPairs;
    use infinite_sea_common::item_production::{Self, ItemProduction};
    use infinite_sea_common::sorted_vector_util;

    use infinite_sea::player::{Self, Player};
    use infinite_sea::player_properties;
    use infinite_sea::skill_process;
    use infinite_sea::skill_process_util;

    friend infinite_sea::skill_process_aggregate;

    const EProcessAlreadyStarted: u64 = 10;
    //const EInvalidPlayerId: u64 = 11;
    //const EIncorrectSkillType: u64 = 12;
    const ENotEnoughEnergy: u64 = 13;
    const ELowerThanRequiredLevel: u64 = 14;
    //const EIsMutexSkillType: u64 = 15;
    const ESenderHasNoPermission: u64 = 22;
    const EItemIdIsNotShip: u64 = 24;
    const EMaterialsMismatch: u64 = 25;
    const ENotEnoughMaterials: u64 = 26;

    public(friend) fun verify(
        production_materials: ItemIdQuantityPairs,
        player: &mut Player,
        item_production: &ItemProduction,
        clock: &Clock,
        energy: &Balance<ENERGY>,
        skill_process: &skill_process::SkillProcess,
        ctx: &TxContext,
    ): skill_process::ShipProductionProcessStarted {
        assert!(sui::tx_context::sender(ctx) == player::owner(player), ESenderHasNoPermission);
        assert!(
            skill_process::item_id(skill_process) == item_id::unused_item() || skill_process::completed(skill_process),
            EProcessAlreadyStarted
        );
        let (_player_id, skill_type, item_id) = skill_process_util::assert_ids_are_consistent_for_starting_production(
            player, item_production, skill_process
        );
        //assert!(skill_process_util::is_non_mutex_skill(skill_type), EIsMutexSkillType);
        assert!(item_id::ship() == item_id, EItemIdIsNotShip);

        let requirements_level = item_production::requirements_level(item_production);
        assert!(player::level(player) >= requirements_level, ELowerThanRequiredLevel);

        let base_creation_time = item_production::base_creation_time(item_production);
        let energy_cost = balance::value(energy);
        assert!(energy_cost >= item_production::energy_cost(item_production), ENotEnoughEnergy);
        let creation_time = base_creation_time;// todo ?
        let basic_production_materials = item_id_quantity_pairs::items(
            &item_production::production_materials(item_production)
        );
        let actual_production_materials = item_id_quantity_pairs::items(&production_materials);
        let i = 0;
        let l = vector::length(&basic_production_materials);
        while (i < l) {
            let p = vector::borrow(&basic_production_materials, i);
            let item_id = item_id_quantity_pair::item_id(p);
            let basic_quantity = item_id_quantity_pair::quantity(p);
            let actual_p_idx = sorted_vector_util::find_item_id_quantity_pair_by_item_id(
                &actual_production_materials,
                item_id
            );
            assert!(option::is_some(&actual_p_idx), EMaterialsMismatch);
            let actual_p = vector::borrow(&actual_production_materials, *option::borrow(&actual_p_idx));
            let actual_quantity = item_id_quantity_pair::quantity(actual_p);
            assert!(actual_quantity >= basic_quantity, ENotEnoughMaterials);
            i = i + 1;
        };
        skill_process::new_ship_production_process_started(
            skill_process,
            item_id,
            energy_cost,
            clock::timestamp_ms(clock) / 1000,
            creation_time,
            production_materials,
        )
    }

    public(friend) fun mutate(
        ship_production_process_started: &skill_process::ShipProductionProcessStarted,
        energy: Balance<ENERGY>,
        player: &mut Player,
        skill_process: &mut skill_process::SkillProcess,
        ctx: &mut TxContext, // modify the reference to mutable if needed
    ) {
        let item_id = skill_process::ship_production_process_started_item_id(ship_production_process_started);
        let started_at = skill_process::ship_production_process_started_started_at(ship_production_process_started);
        //let skill_process_id = skill_process::skill_process_id(skill_process);
        //let energy_cost = skill_process::ship_production_process_started_energy_cost(ship_production_process_started);
        let creation_time = skill_process::ship_production_process_started_creation_time(
            ship_production_process_started
        );
        let production_materials = skill_process::ship_production_process_started_production_materials(
            ship_production_process_started
        );
        skill_process::set_item_id(skill_process, item_id);
        skill_process::set_started_at(skill_process, started_at);
        skill_process::set_creation_time(skill_process, creation_time);
        skill_process::set_completed(skill_process, false);
        skill_process::set_ended_at(skill_process, 0);

        let energy_vault = skill_process::borrow_mut_energy_vault(skill_process);
        balance::join(energy_vault, energy);

        player_properties::deduct_inventory(player, item_id_quantity_pairs::items(&production_materials));
    }
}
