module infinite_sea_common::ts_random_util {

    use std::hash;
    use std::vector;

    use sui::bcs;
    use sui::clock::{Self, Clock};
    use sui::tx_context::{Self, TxContext};

    public fun get_int(clock: &Clock, seed: vector<u8>, bound: u64): u64 {
        (get_u256(clock, seed) % (bound as u256) as u64)
    }

    public fun get_u256(clock: &Clock, seed: vector<u8>): u256 {
        let now = clock::timestamp_ms(clock);
        let bs = bcs::to_bytes(&now);
        vector::append(&mut bs, seed);
        let hash = hash::sha3_256(bs);
        let bcs = bcs::new(hash);
        bcs::peel_u256(&mut bcs)
    }

    public fun divide_int(clock: &Clock, seed: vector<u8>, value: u64, n: u64): vector<u64> {
        let result = vector::empty<u64>();
        let remaining = value;
        let i = 0;
        while (i < n) {
            if (i == n - 1) {
                vector::push_back(&mut result, remaining);
                break
            };
            vector::append(&mut seed, bcs::to_bytes(&i));
            let bound = remaining + 1;
            let r = get_int(clock, seed, bound);
            vector::push_back(&mut result, r);
            remaining = remaining - r;
            i = i + 1;
        };
        result
    }

    /// Randomly splits an integer `value` into `n` integers whose sum is equal to the value.
    public fun divide_int_with_epoch_timestamp_ms(cxt: &TxContext, seed: vector<u8>, value: u64, n: u64): vector<u64> {
        let result = vector::empty<u64>();
        let remaining = value;
        let i = 0;
        while (i < n) {
            if (i == n - 1) {
                vector::push_back(&mut result, remaining);
                break
            };
            vector::append(&mut seed, bcs::to_bytes(&i));
            let bound = remaining + 1;
            let r = get_int_with_epoch_timestamp_ms(cxt, seed, bound);
            vector::push_back(&mut result, r);
            remaining = remaining - r;
            i = i + 1;
        };
        result
    }

    /// Get pseudo-random u64 with epoch timestamp in milliseconds and another value as seed.
    public fun get_int_with_epoch_timestamp_ms(cxt: &TxContext, seed: vector<u8>, bound: u64): u64 {
        (get_u256_with_epoch_timestamp_ms(cxt, seed) % (bound as u256) as u64)
    }

    /// Get pseudo-random u256 with epoch timestamp in milliseconds and another value as seed.
    public fun get_u256_with_epoch_timestamp_ms(cxt: &TxContext, seed: vector<u8>): u256 {
        let bs = bcs::to_bytes(&tx_context::epoch_timestamp_ms(cxt));
        vector::append(&mut bs, seed);
        let hash = hash::sha3_256(bs);
        let bcs = bcs::new(hash);
        bcs::peel_u256(&mut bcs)
    }
}
