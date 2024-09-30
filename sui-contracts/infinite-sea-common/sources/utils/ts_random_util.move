/// Warning: use this module with caution in production environments.
/// Generating random numbers based on timestamps is vulnerable to malicious manipulation.
/// Consider using the `sui::random` module.
module infinite_sea_common::ts_random_util {
    use std::hash;
    use std::vector;

    use sui::bcs;
    use sui::clock::{Self, Clock};
    use sui::tx_context::{Self, TxContext};

    const MAX_U32: u32 = 4_294_967_295;
    const MAX_U64: u64 = 18_446_744_073_709_551_615;

    public fun get_int(clock: &Clock, seed: vector<u8>, bound: u64): u64 {
        (get_u256(clock, seed) % (bound as u256) as u64)
    }

    public fun get_8_u32_vector(clock: &Clock, seed: vector<u8>): vector<u32> {
        let u_o = get_u256(clock, seed);
        let u1 = ((u_o % (MAX_U32 as u256)) as u32);
        let u2 = (((u_o >> 32) % (MAX_U32 as u256)) as u32);
        let u3 = (((u_o >> 64) % (MAX_U32 as u256)) as u32);
        let u4 = (((u_o >> 96) % (MAX_U32 as u256)) as u32);
        let u5 = (((u_o >> 128) % (MAX_U32 as u256)) as u32);
        let u6 = (((u_o >> 160) % (MAX_U32 as u256)) as u32);
        let u7 = (((u_o >> 192) % (MAX_U32 as u256)) as u32);
        let u8 = (((u_o >> 224) % (MAX_U32 as u256)) as u32);
        vector[u1, u2, u3, u4, u5, u6, u7, u8]
    }

    /// Get four u64 integers.
    public fun get_4_u64(clock: &Clock, seed: vector<u8>): (u64, u64, u64, u64) {
        let u_o = get_u256(clock, seed);
        let u1 = ((u_o % (MAX_U64 as u256)) as u64);
        let u2 = (((u_o >> 64) % (MAX_U64 as u256)) as u64);
        let u3 = (((u_o >> 128) % (MAX_U64 as u256)) as u64);
        let u4 = (((u_o >> 192) % (MAX_U64 as u256)) as u64);
        (u1, u2, u3, u4)
    }

    public fun get_u256(clock: &Clock, seed: vector<u8>): u256 {
        let now = clock::timestamp_ms(clock);
        let bs = bcs::to_bytes(&now);
        vector::append(&mut bs, seed);
        let hash = hash::sha2_256(bs);
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
        let hash = hash::sha2_256(bs);
        let bcs = bcs::new(hash);
        bcs::peel_u256(&mut bcs)
    }
}
