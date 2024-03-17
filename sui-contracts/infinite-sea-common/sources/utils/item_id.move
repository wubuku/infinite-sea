module infinite_sea_common::item_id {
    use infinite_sea_common::skill_type;

    const EInvalidSkillType: u64 = 10;

    const UNUSED_ITEM: u32 = 0;

    const RESOURCE_TYPE_WOODCUTTING: u32 = 2_000_000_001;
    const RESOURCE_TYPE_FISHING: u32 = 2_000_000_002;
    const RESOURCE_TYPE_MINING: u32 = 2_000_000_003;

    //const RESOURCE_TYPE_SMITHING: u32 = 2_000_000_004;
    //const RESOURCE_TYPE_COOKING: u32 = 2_000_000_005;
    //const RESOURCE_TYPE_CRAFTING: u32 = 2_000_000_006;
    //const RESOURCE_TYPE_TOWNSHIP: u32 = 2_000_000_007;

    public fun unused_item(): u32 {
        UNUSED_ITEM
    }

    public fun resource_type_woodcutting(): u32 {
        RESOURCE_TYPE_WOODCUTTING
    }

    public fun resource_type_fishing(): u32 {
        RESOURCE_TYPE_FISHING
    }

    public fun resource_type_mining(): u32 {
        RESOURCE_TYPE_MINING
    }

    // public fun resource_type_smithing(): u32 {
    // }

    public fun resource_type_required_for_skill(skill_type: u8): u32 {
        if (skill_type == skill_type::woodcutting()) {
            RESOURCE_TYPE_WOODCUTTING
        } else if (skill_type == skill_type::fishing()) {
            RESOURCE_TYPE_FISHING
        } else if (skill_type == skill_type::mining()) {
            RESOURCE_TYPE_MINING
        } else {
            abort EInvalidSkillType
        }
    }
}
