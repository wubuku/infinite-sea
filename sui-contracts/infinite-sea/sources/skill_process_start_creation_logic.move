#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::skill_process_start_creation_logic {
    use sui::balance::{Self, Balance};
    use sui::clock::{Self, Clock};
    use sui::tx_context::TxContext;
    use infinite_sea_coin::energy::ENERGY;
    use infinite_sea_common::item_creation::{Self, ItemCreation};
    use infinite_sea_common::item_id;
    use infinite_sea_common::item_id_quantity_pair;
    use infinite_sea_common::skill_process_id;

    use infinite_sea::player::{Self, Player};
    use infinite_sea::player_properties;
    use infinite_sea::skill_process;
    use infinite_sea::skill_process_util;

    // use infinite_sea::skill_process_mutex;
    // use infinite_sea::skill_process_mutex::SkillProcessMutex;
    // use infinite_sea::skill_process_mutex_aggregate;
    friend infinite_sea::skill_process_aggregate;

    const EProcessAlreadyStarted: u64 = 10;
    const ENotEnoughEnergy: u64 = 13;
    const ELowerThanRequiredLevel: u64 = 14;
    // const EIsNonMutexSkillType: u64 = 15;
    const ESenderHasNoPermission: u64 = 22;
    // const EInvalidMutexPlayerId: u64 = 23;

    public(friend) fun verify(
        // skill_process_mutex: &SkillProcessMutex,
        player: &mut Player,
        item_creation: &ItemCreation,
        clock: &Clock,
        energy: &Balance<ENERGY>,
        skill_process: &skill_process::SkillProcess,
        ctx: &TxContext,
    ): skill_process::CreationProcessStarted {
        assert!(sui::tx_context::sender(ctx) == player::owner(player), ESenderHasNoPermission);
        assert!(
            skill_process::item_id(skill_process) == item_id::unused_item() || skill_process::completed(skill_process),
            EProcessAlreadyStarted
        );
        let (player_id, skill_type, item_id) = skill_process_util::assert_ids_are_consistent_for_starting_creation(
            player, item_creation, skill_process
        );
        // assert!(skill_process_mutex::player_id(skill_process_mutex) == player_id, EInvalidMutexPlayerId);
        // assert!(skill_process_util::is_mutex_skill(skill_type), EIsNonMutexSkillType);

        let requirements_level = item_creation::requirements_level(item_creation);
        assert!(player::level(player) >= requirements_level, ELowerThanRequiredLevel);

        let base_creation_time = item_creation::base_creation_time(item_creation);
        let energy_cost = balance::value(energy);
        assert!(energy_cost >= item_creation::energy_cost(item_creation), ENotEnoughEnergy);
        let creation_time = base_creation_time; // todo level-based or XXX-based creation time calculation?
        let resource_cost = item_creation::resource_cost(item_creation);
        skill_process::new_creation_process_started(
            skill_process,
            item_id,
            energy_cost,
            resource_cost,
            clock::timestamp_ms(clock) / 1000,
            creation_time,
        )
    }

    public(friend) fun mutate(
        creation_process_started: &skill_process::CreationProcessStarted,
        energy: Balance<ENERGY>,
        // skill_process_mutex: &mut SkillProcessMutex,
        player: &mut Player,
        skill_process: &mut skill_process::SkillProcess,
        ctx: &mut TxContext, // modify the reference to mutable if needed
    ) {
        let item_id = skill_process::creation_process_started_item_id(creation_process_started);
        //let energy_cost = skill_process::creation_process_started_energy_cost(creation_process_started);
        let resource_cost = skill_process::creation_process_started_resource_cost(creation_process_started);
        let started_at = skill_process::creation_process_started_started_at(creation_process_started);
        let creation_time = skill_process::creation_process_started_creation_time(creation_process_started);
        let skill_process_id = skill_process::skill_process_id(skill_process);
        let skill_type = skill_process_id::skill_type(&skill_process_id);
        let resource_type = item_id::resource_type_required_for_skill(skill_type);

        // skill_process_mutex_aggregate::lock(skill_process_mutex, skill_type, ctx);

        skill_process::set_item_id(skill_process, item_id);
        skill_process::set_started_at(skill_process, started_at);
        skill_process::set_creation_time(skill_process, creation_time);
        skill_process::set_completed(skill_process, false);
        skill_process::set_ended_at(skill_process, 0);

        let energy_vault = skill_process::borrow_mut_energy_vault(skill_process);
        balance::join(energy_vault, energy);

        let required_resource_items = vector[item_id_quantity_pair::new(resource_type, resource_cost)];

        player_properties::deduct_inventory(player, required_resource_items);
    }
}
