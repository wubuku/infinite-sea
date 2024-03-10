#[allow(unused_mut_parameter)]
module infinite_sea_farming::farming_process_create_logic {
    use infinite_sea_farming::farming_process;
    use sui::tx_context::TxContext;

    friend infinite_sea_farming::farming_process_aggregate;

    public(friend) fun verify(
        farming_process_table: &farming_process::FarmingProcessTable,
        ctx: &mut TxContext,
    ): farming_process::FarmingProcessCreated {
        let player_id = sui::tx_context::sender(ctx);
        farming_process::asset_player_id_not_exists(player_id, farming_process_table);
        farming_process::new_farming_process_created(
            player_id,
        )
    }

    public(friend) fun mutate(
        farming_process_created: &farming_process::FarmingProcessCreated,
        farming_process_table: &mut farming_process::FarmingProcessTable,
        ctx: &mut TxContext,
    ): farming_process::FarmingProcess {
        let player_id = farming_process::farming_process_created_player_id(farming_process_created);
        farming_process::create_farming_process(
            player_id,
            farming_process_table,
            ctx,
        )
    }

}
