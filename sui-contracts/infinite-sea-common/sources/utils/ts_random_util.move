module infinite_sea_common::ts_random_util {

    use std::hash;
    use std::vector;

    use sui::bcs;
    use sui::clock;
    use sui::clock::Clock;

    public fun next_int(clock: &Clock, seed: vector<u8>, bound: u64): u64 {
        (next_u256(clock, seed) % (bound as u256) as u64)
    }

    public fun next_u256(clock: &Clock, seed: vector<u8>): u256 {
        let now = clock::timestamp_ms(clock);
        let bs = bcs::to_bytes(&now);
        vector::append(&mut bs, seed);
        let hash = hash::sha3_256(bs);
        let bcs = bcs::new(hash);
        bcs::peel_u256(&mut bcs)
    }
}
