#[test_only]
module infinite_sea_common::ts_random_util_tests {

    use std::debug;
    use std::vector;

    use sui::clock;
    use sui::test_scenario;

    use infinite_sea_common::ts_random_util;

    #[test]
    public fun test_1() {
        // Create test addresses representing users
        let initial_owner = @0xCAFE;
        //let final_owner = @0xFACE;

        // First transaction executed
        let scenario = test_scenario::begin(initial_owner);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            let random_ints = ts_random_util::divide_int_with_epoch_timestamp_ms(ctx, b"hxelssxgagdslso", 8, 3);
            let i = 0;
            let l = vector::length(&random_ints);
            while (i < l) {
                let random_int = vector::borrow(&random_ints, i);
                //debug::print(random_int);
                i = i + 1;
            }
        };
        test_scenario::end(scenario);
    }

    #[test]
    public fun test_2() {
        // Create test addresses representing users
        let initial_owner = @0xCAFE;
        //let final_owner = @0xFACE;

        // First transaction executed
        let scenario = test_scenario::begin(initial_owner);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            let clock = clock::create_for_testing(ctx);
            let random_u32_vector = ts_random_util::get_8_u32_vector(&clock, b"hxelssxgagdslso");
            //debug::print(&random_u32_vector);
            clock::destroy_for_testing(clock);
        };
        test_scenario::end(scenario);
    }
}
