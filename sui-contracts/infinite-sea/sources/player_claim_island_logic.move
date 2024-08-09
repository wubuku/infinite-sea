#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::player_claim_island_logic {
    use std::option;
    use std::vector;

    use sui::clock;
    use sui::clock::Clock;
    use sui::table;
    use sui::tx_context;
    use sui::tx_context::TxContext;
    use infinite_sea_common::coordinates::Coordinates;
    use infinite_sea_common::roster_status;
    use infinite_sea_common::skill_type;
    use infinite_sea_map::map;
    use infinite_sea_map::map::Map;
    use infinite_sea_map::map_friend_config;

    use infinite_sea::player;
    use infinite_sea::player_properties;
    use infinite_sea::roster;
    use infinite_sea::roster::RosterTable;
    use infinite_sea::roster_aggregate;
    use infinite_sea::skill_process::SkillProcessTable;
    use infinite_sea::skill_process_aggregate;

    friend infinite_sea::player_aggregate;

    const ESenderHasNoPermission: u64 = 22;
    const EPlayerAlreadyClaimedIsland: u64 = 23;
    const EForNftHoldersOnly: u64 = 24;
    const ENotForEveryone: u64 = 25;
    const EInvalidClaimIslandSetting: u64 = 26;
    const EInvalidCoordinates: u64 = 27;

    const FOR_NFT_HOLDERS_ONLY: u8 = 1;
    const FOR_WHITELISTED_ACCOUNTS_ONLY: u8 = 2;
    const FOR_EVERYONE: u8 = 3;

    public(friend) fun verify(
        map: &mut Map,
        coordinates: Coordinates,
        clock: &Clock,
        roster_table: &mut RosterTable,
        skill_process_table: &mut SkillProcessTable,
        player: &player::Player,
        ctx: &TxContext,
    ): player::IslandClaimed {
        assert!(map::locations_contains(map, coordinates), EInvalidCoordinates);
        //let for_nft_holders_only = map::for_nft_holders_only(map);
        let claim_island_setting_o = map::claim_island_setting(map);
        let claim_island_setting = if (option::is_none(&claim_island_setting_o)) {
            FOR_EVERYONE
        } else {
            *option::borrow(&claim_island_setting_o)
        };
        assert!(
            claim_island_setting != FOR_NFT_HOLDERS_ONLY, //option::is_none(&for_nft_holders_only) || !*option::borrow(&for_nft_holders_only),
            EForNftHoldersOnly
        );
        if (claim_island_setting != FOR_EVERYONE) {
            if (claim_island_setting == FOR_WHITELISTED_ACCOUNTS_ONLY) {
                let whitelist = map::borrow_claim_island_whitelist(map);
                assert!(
                    table::contains(whitelist, tx_context::sender(ctx)),
                    ENotForEveryone
                );
            } else {
                abort EInvalidClaimIslandSetting
            }
        };
        assert!(sui::tx_context::sender(ctx) == player::owner(player), ESenderHasNoPermission);
        assert!(option::is_none(&player::claimed_island(player)), EPlayerAlreadyClaimedIsland);

        let claimed_at = clock::timestamp_ms(clock) / 1000;
        player::new_island_claimed(player, coordinates, claimed_at)
    }

    public(friend) fun mutate(
        map_friend_config: &map_friend_config::MapFriendConfig,
        island_claimed: &player::IslandClaimed,
        map: &mut Map,
        roster_table: &mut RosterTable,
        skill_process_table: &mut SkillProcessTable,
        player: &mut player::Player,
        ctx: &mut TxContext, // modify the reference to mutable if needed
    ) {
        let coordinates = player::island_claimed_coordinates(island_claimed);
        let claimed_at = player::island_claimed_claimed_at(island_claimed);
        let player_id = player::id(player);

        player_properties::claim_island_mutate(map_friend_config, player, map, coordinates, claimed_at, false, ctx);

        // create skill processes after claiming the island
        let skill_types = vector[
            skill_type::mining(), skill_type::woodcutting(), skill_type::farming(), skill_type::crafting()
        ];
        let i = 0;
        let l = vector::length(&skill_types);
        while (i < l) {
            let skill_type = *vector::borrow(&skill_types, i);
            let max_seq_number = infinite_sea::skill_process_util::skill_type_max_sequence_number(skill_type);
            let seq_number = 0;
            while (seq_number <= max_seq_number) {
                skill_process_aggregate::create(skill_type, player_id, seq_number, player, skill_process_table, ctx);
                seq_number = seq_number + 1;
            };
            i = i + 1;
        };

        // create rosters after claiming the island
        let roster_sequence_number: u32 = 0;
        while (roster_sequence_number < 5) {
            // 0-4
            let r = roster_aggregate::create(player_id, roster_sequence_number, roster_status::at_anchor(), 0,
                infinite_sea_common::roster_util::get_roster_origin_coordinates(&coordinates, roster_sequence_number),
                0, option::none(), option::none(),
                option::none(), roster_table, ctx
            );
            roster::share_object(r);
            roster_sequence_number = roster_sequence_number + 1;
        };
    }
}
