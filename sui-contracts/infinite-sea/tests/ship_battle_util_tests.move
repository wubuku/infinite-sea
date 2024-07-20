#[test_only]
module infinite_sea::ship_battle_util_tests {
    use std::debug;

    use sui::clock;
    use sui::test_scenario;

    use infinite_sea::ship_battle_util;

    // #[test]
    // public fun test_1() {
    //     let initial_owner = @0xCAFE;
    //     let scenario = test_scenario::begin(initial_owner);
    //     {
    //         let ctx = test_scenario::ctx(&mut scenario);
    //         let clock = clock::create_for_testing(ctx);
    //         clock::set_for_testing(&mut clock, 97921791939237597);
    //         let i = 0;
    //         let l = 100;
    //         while (i < l) {
    //             let seed = vector[i];
    //             //let d = ship_battle_util::perform_attack(seed, &clock, 4, 5);
    //             //let d = ship_battle_util::perform_attack(seed, &clock, 5, 4);
    //             let d = ship_battle_util::perform_attack(seed, &clock, 5, 5);
    //             debug::print(&d);
    //             i = i + 1;
    //         };
    //         clock::destroy_for_testing(clock);
    //     };
    //     test_scenario::end(scenario);
    // }
}
