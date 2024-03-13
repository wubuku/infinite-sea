// Copyright (c) Mysten Labs, Inc.
// SPDX-License-Identifier: Apache-2.0

/// Example coin with a trusted owner responsible for minting/burning (e.g., a stablecoin)
module infinite_sea_coin::energy {
    use std::option;

    use sui::coin::{Self, Coin, TreasuryCap};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    /// Name of the coin
    struct ENERGY has drop {}

    /// Register the trusted currency to acquire its `TreasuryCap`. Because
    /// this is a module initializer, it ensures the currency only gets
    /// registered once.
    fun init(otw: ENERGY, ctx: &mut TxContext) {
        // Get a treasury cap for the coin and give it to the transaction
        // sender
        let (treasury_cap, metadata) = coin::create_currency<ENERGY>(otw, 2, b"ENERGY", b"", b"", option::none(), ctx);
        transfer::public_freeze_object(metadata);
        transfer::public_transfer(treasury_cap, tx_context::sender(ctx))
    }

    #[lint_allow(self_transfer)]
    public entry fun mint(treasury_cap: &mut TreasuryCap<ENERGY>, amount: u64, ctx: &mut TxContext) {
        let coin = coin::mint<ENERGY>(treasury_cap, amount, ctx);
        transfer::public_transfer(coin, tx_context::sender(ctx));
    }

    #[lint_allow(self_transfer)]
    public entry fun split_and_self_transfer(coin: &mut Coin<ENERGY>, split_amount: u64, ctx: &mut TxContext) {
        let coin_s = coin::split(coin, split_amount, ctx);
        transfer::public_transfer(coin_s, tx_context::sender(ctx));
    }

    #[test_only]
    /// Wrapper of module initializer for testing
    public fun test_init(ctx: &mut TxContext) {
        init(ENERGY {}, ctx)
    }
}
