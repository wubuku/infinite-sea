#[allow(unused_mut_parameter)]
module infinite_sea_nft::avatar_change_create_logic {
    use infinite_sea_nft::avatar_change;
    use std::option::{Option};
    use std::string::String;
    use sui::object::ID;
    use sui::tx_context::TxContext;

    friend infinite_sea_nft::avatar_change_aggregate;

    public(friend) fun verify(
        avatar_id: ID,
        image_url: String,
        background_color: Option<u32>,
        haircut: Option<u8>,
        outfit: Option<u8>,
        accessories: vector<u8>,
        aura: Option<u8>,
        symbols: vector<u8>,
        effects: vector<u8>,
        backgrounds: vector<u8>,
        decorations: vector<u8>,
        badges: vector<u8>,
        avatar_change_table: &avatar_change::AvatarChangeTable,
        ctx: &mut TxContext,
    ): avatar_change::AvatarChangeCreated {
        let _ = ctx;
        avatar_change::asset_avatar_id_not_exists(avatar_id, avatar_change_table);
        avatar_change::new_avatar_change_created(
            avatar_id,
            image_url,
            background_color,
            haircut,
            outfit,
            accessories,
            aura,
            symbols,
            effects,
            backgrounds,
            decorations,
            badges,
        )
    }

    public(friend) fun mutate(
        avatar_change_created: &avatar_change::AvatarChangeCreated,
        avatar_change_table: &mut avatar_change::AvatarChangeTable,
        ctx: &mut TxContext,
    ): avatar_change::AvatarChange {
        let avatar_id = avatar_change::avatar_change_created_avatar_id(avatar_change_created);
        let image_url = avatar_change::avatar_change_created_image_url(avatar_change_created);
        let background_color = avatar_change::avatar_change_created_background_color(avatar_change_created);
        let haircut = avatar_change::avatar_change_created_haircut(avatar_change_created);
        let outfit = avatar_change::avatar_change_created_outfit(avatar_change_created);
        let accessories = avatar_change::avatar_change_created_accessories(avatar_change_created);
        let aura = avatar_change::avatar_change_created_aura(avatar_change_created);
        let symbols = avatar_change::avatar_change_created_symbols(avatar_change_created);
        let effects = avatar_change::avatar_change_created_effects(avatar_change_created);
        let backgrounds = avatar_change::avatar_change_created_backgrounds(avatar_change_created);
        let decorations = avatar_change::avatar_change_created_decorations(avatar_change_created);
        let badges = avatar_change::avatar_change_created_badges(avatar_change_created);
        avatar_change::create_avatar_change(
            avatar_id,
            image_url,
            background_color,
            haircut,
            outfit,
            accessories,
            aura,
            symbols,
            effects,
            backgrounds,
            decorations,
            badges,
            avatar_change_table,
            ctx,
        )
    }

}
