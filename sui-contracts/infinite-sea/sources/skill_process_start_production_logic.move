#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::skill_process_start_production_logic {
    use sui::balance;
    use sui::balance::Balance;
    use sui::clock;
    use sui::clock::Clock;
    use sui::tx_context::TxContext;
    use infinite_sea_common::item_id;
    use infinite_sea_common::production_materials;
    use infinite_sea_common::skill_type_item_id_pair;
    use infinite_sea_common::skill_type_player_id_pair;

    use infinite_sea::item_production::{Self, ItemProduction};
    use infinite_sea::player;
    use infinite_sea::player::Player;
    use infinite_sea::player_aggregate;
    use infinite_sea::skill_process;
    use infinite_sea::skill_process::production_process_started_started_at;

    friend infinite_sea::skill_process_aggregate;

    const EProcessAlreadyStarted: u64 = 10;
    const EInvalidPlayerId: u64 = 11;
    const EIncorrectSkillType: u64 = 12;
    const ENotEnoughEnergy: u64 = 13;
    const ELowerThanRequiredLevel: u64 = 14;
    const ESenderHasNoPermission: u64 = 22;

    public(friend) fun verify(
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
        let skill_process_id = skill_process::skill_process_id(skill_process);
        let player_id = infinite_sea_common::skill_type_player_id_pair::player_id(&skill_process_id);
        assert!(player::id(player) == player_id, EInvalidPlayerId);

        let item_production_id = item_production::item_production_id(item_production);
        let skill_type = skill_type_item_id_pair::skill_type(&item_production_id);
        assert!(skill_type == skill_type_player_id_pair::skill_type(&skill_process_id), EIncorrectSkillType);
        let item_id = skill_type_item_id_pair::item_id(&item_production_id);

        let requirements_level = item_production::requirements_level(item_production);
        assert!(player::level(player) >= requirements_level, ELowerThanRequiredLevel);

        let base_creation_time = item_production::base_creation_time(item_production);
        let energy_cost = balance::value(energy);
        assert!(energy_cost >= item_production::energy_cost(item_production), ENotEnoughEnergy);
        let creation_time = base_creation_time;// todo ?
        let production_materials = item_production::production_materials(item_production);
        skill_process::new_production_process_started(
            skill_process,
            item_id,
            energy_cost,
            clock::timestamp_ms(clock) / 1000,
            creation_time,
            production_materials,
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
        //let skill_process_id = skill_process::skill_process_id(skill_process);
        //let energy_cost = skill_process::production_process_started_energy_cost(production_process_started);
        let production_materials = skill_process::production_process_started_production_materials(
            production_process_started
        );
        skill_process::set_item_id(skill_process, item_id);
        skill_process::set_started_at(skill_process, started_at);
        skill_process::set_completed(skill_process, false);
        skill_process::set_ended_at(skill_process, 0);

        let energy_vault = skill_process::borrow_mut_energy_vault(skill_process);
        balance::join(energy_vault, energy);

        player_aggregate::deduct_items(player, production_materials::items(&production_materials), ctx);
    }
}
