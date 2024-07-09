#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea_nft::avatar_update_logic {
    use std::option;
    use std::string;

    use sui::tx_context;
    use sui::tx_context::TxContext;

    use infinite_sea_nft::avatar;
    use infinite_sea_nft::avatar_change;
    use infinite_sea_nft::avatar_change::AvatarChange;
    use infinite_sea_nft::sorted_u8_vector_util;

    friend infinite_sea_nft::avatar_aggregate;

    const EInvalidSender: u64 = 101;
    const EAvatarIdMismatch: u64 = 102;

    public(friend) fun verify(
        avatar_change: &AvatarChange,
        avatar: &mut avatar::Avatar,
        ctx: &TxContext,
    ): avatar::AvatarUpdated {
        assert!(avatar::owner(avatar) == tx_context::sender(ctx), EInvalidSender); // Is this necessary?
        assert!(avatar::id(avatar) == avatar_change::avatar_id(avatar_change), EAvatarIdMismatch);

        // ImageUrl:
        //   type: String
        let image_url = avatar_change::image_url(avatar_change);
        if (!string::is_empty(&image_url)) {
            avatar::set_image_url(avatar, image_url);
        };
        //# ------------------------
        // BackgroundColor:
        //   type: u32
        //   optional: true
        let background_color = avatar_change::background_color(avatar_change);
        if (option::is_some(&background_color)) {
            avatar::set_background_color(avatar, *option::borrow(&background_color));
        };
        // Haircut:
        //   type: u8
        //   optional: true
        let haircut = avatar_change::haircut(avatar_change);
        if (option::is_some(&haircut)) {
            avatar::set_haircut(avatar, *option::borrow(&haircut));
        };
        // Outfit:
        //   type: u8
        //   optional: true
        let outfit = avatar_change::outfit(avatar_change);
        if (option::is_some(&outfit)) {
            avatar::set_outfit(avatar, *option::borrow(&outfit));
        };
        // Accessories:
        //   type: vector<u8>
        let accessories = sorted_u8_vector_util::sort_and_merge_u8_vectors(
            &avatar::accessories(avatar),
            &avatar_change::accessories(avatar_change),
        );
        avatar::set_accessories(avatar, accessories);
        //# ------------------------
        // Aura:
        //   type: u8
        //   optional: true
        let aura = avatar_change::aura(avatar_change);
        if (option::is_some(&aura)) {
            avatar::set_aura(avatar, *option::borrow(&aura));
        };
        // Symbols:
        //   type: vector<u8>
        let symbols = sorted_u8_vector_util::sort_and_merge_u8_vectors(
            &avatar::symbols(avatar),
            &avatar_change::symbols(avatar_change),
        );
        avatar::set_symbols(avatar, symbols);
        // Effects:
        //   type: vector<u8>
        let effects = sorted_u8_vector_util::sort_and_merge_u8_vectors(
            &avatar::effects(avatar),
            &avatar_change::effects(avatar_change),
        );
        avatar::set_effects(avatar, effects);
        // Backgrounds:
        //   type: vector<u8>
        let backgrounds = sorted_u8_vector_util::sort_and_merge_u8_vectors(
            &avatar::backgrounds(avatar),
            &avatar_change::backgrounds(avatar_change),
        );
        avatar::set_backgrounds(avatar, backgrounds);
        // Decorations:
        //   type: vector<u8>
        let decorations = sorted_u8_vector_util::sort_and_merge_u8_vectors(
            &avatar::decorations(avatar),
            &avatar_change::decorations(avatar_change),
        );
        avatar::set_decorations(avatar, decorations);
        // Badges:
        //   type: vector<u8>
        let badges = sorted_u8_vector_util::sort_and_merge_u8_vectors(
            &avatar::badges(avatar),
            &avatar_change::badges(avatar_change),
        );
        avatar::set_badges(avatar, badges);

        avatar::new_avatar_updated(avatar)
    }

    public(friend) fun mutate(
        avatar_updated: &avatar::AvatarUpdated,
        avatar: avatar::Avatar,
        ctx: &TxContext, // modify the reference to mutable if needed
    ): avatar::Avatar {
        let id = avatar::id(&avatar);
        avatar
    }
}
