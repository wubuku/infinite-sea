module infinite_sea_nft::avatar_change_update_logic {
    use infinite_sea_nft::avatar_change;
    use std::option::{Option};
    use std::string::String;
    use sui::tx_context::TxContext;

    friend infinite_sea_nft::avatar_change_aggregate;

    public(friend) fun verify(
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
        avatar_change: &avatar_change::AvatarChange,
        ctx: &TxContext,
    ): avatar_change::AvatarChangeUpdated {
        let _ = ctx;
        avatar_change::new_avatar_change_updated(
            avatar_change,
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
        avatar_change_updated: &avatar_change::AvatarChangeUpdated,
        avatar_change: &mut avatar_change::AvatarChange,
        ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        let image_url = avatar_change::avatar_change_updated_image_url(avatar_change_updated);
        let background_color = avatar_change::avatar_change_updated_background_color(avatar_change_updated);
        let haircut = avatar_change::avatar_change_updated_haircut(avatar_change_updated);
        let outfit = avatar_change::avatar_change_updated_outfit(avatar_change_updated);
        let accessories = avatar_change::avatar_change_updated_accessories(avatar_change_updated);
        let aura = avatar_change::avatar_change_updated_aura(avatar_change_updated);
        let symbols = avatar_change::avatar_change_updated_symbols(avatar_change_updated);
        let effects = avatar_change::avatar_change_updated_effects(avatar_change_updated);
        let backgrounds = avatar_change::avatar_change_updated_backgrounds(avatar_change_updated);
        let decorations = avatar_change::avatar_change_updated_decorations(avatar_change_updated);
        let badges = avatar_change::avatar_change_updated_badges(avatar_change_updated);
        let avatar_id = avatar_change::avatar_id(avatar_change);
        let _ = ctx;
        let _ = avatar_id;
        avatar_change::set_image_url(avatar_change, image_url);
        avatar_change::set_background_color(avatar_change, background_color);
        avatar_change::set_haircut(avatar_change, haircut);
        avatar_change::set_outfit(avatar_change, outfit);
        avatar_change::set_accessories(avatar_change, accessories);
        avatar_change::set_aura(avatar_change, aura);
        avatar_change::set_symbols(avatar_change, symbols);
        avatar_change::set_effects(avatar_change, effects);
        avatar_change::set_backgrounds(avatar_change, backgrounds);
        avatar_change::set_decorations(avatar_change, decorations);
        avatar_change::set_badges(avatar_change, badges);
    }

}
