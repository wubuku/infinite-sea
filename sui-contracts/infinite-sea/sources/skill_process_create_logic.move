#[allow(unused_mut_parameter)]
module infinite_sea::skill_process_create_logic {
    use infinite_sea::player::{Self, Player};
    use infinite_sea::skill_process;
    use infinite_sea_common::skill_process_id::SkillProcessId;
    use sui::tx_context::TxContext;

    friend infinite_sea::skill_process_aggregate;

    const EInvalidPlayerId: u64 = 10;
    const ESenderHasNoPermission: u64 = 22;
    const EInvalidSequenceNumber: u64 = 23;

    public(friend) fun verify(
        skill_process_id: SkillProcessId,
        player: &Player,
        skill_process_table: &skill_process::SkillProcessTable,
        ctx: &mut TxContext,
    ): skill_process::SkillProcessCreated {
        let _ = ctx;
        assert!(sui::tx_context::sender(ctx) == player::owner(player), ESenderHasNoPermission);
        let player_id = infinite_sea_common::skill_process_id::player_id(&skill_process_id);
        assert!(player::id(player) == player_id, EInvalidPlayerId);
        assert!(
            infinite_sea_common::skill_process_id::sequence_number(
                &skill_process_id
            ) <= infinite_sea::skill_process_util::skill_type_max_sequence_number(
                infinite_sea_common::skill_process_id::skill_type(&skill_process_id)
            ),
            EInvalidSequenceNumber
        );

        skill_process::asset_skill_process_id_not_exists(skill_process_id, skill_process_table);
        skill_process::new_skill_process_created(
            skill_process_id,
        )
    }

    public(friend) fun mutate(
        skill_process_created: &skill_process::SkillProcessCreated,
        skill_process_table: &mut skill_process::SkillProcessTable,
        ctx: &mut TxContext,
    ): skill_process::SkillProcess {
        let skill_process_id = skill_process::skill_process_created_skill_process_id(skill_process_created);
        skill_process::create_skill_process(
            skill_process_id,
            skill_process_table,
            ctx,
        )
    }

}
