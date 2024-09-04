#[test_only]
module infinite_sea_common::fight_to_death_tests {
    use std::debug;
    use std::vector;

    use sui::clock;
    use sui::test_scenario;

    use infinite_sea_common::fight_to_death;

    #[test]
    public fun test_1() {
        let seed: vector<u8> = b"gagjalgsssxsffi";
        let self_attack = 5;
        let self_protection = 6;
        let self_health = 4;
        let opponent_attack = 5;
        let opponent_protection = 6;
        let opponent_health = 9;

        let initial_owner = @0xCAFE;
        //let final_owner = @0xFACE;

        let win_count = 0;
        let lose_count = 0;
        // First transaction executed
        let scenario = test_scenario::begin(initial_owner);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            let clock = clock::create_for_testing(ctx);
            let i = 0;
            while (i < 100) {
                clock::increment_for_testing(&mut clock, 232324);
                vector::append(&mut seed, vector[i]);
                let (self_damage_taken, opponent_damage_taken) = fight_to_death::perform(&clock,
                    seed,
                    self_attack, self_protection, self_health, opponent_attack, opponent_protection, opponent_health
                );
                debug::print(&self_damage_taken);
                debug::print(&opponent_damage_taken);
                assert!(!(self_damage_taken == self_health && opponent_damage_taken == opponent_health), 1);
                assert!(self_damage_taken == self_health || opponent_damage_taken == opponent_health, 2);
                if (self_damage_taken != self_health) {
                    win_count = win_count + 1;
                } else {
                    lose_count = lose_count + 1;
                };
                i = i + 1;
            };
            clock::destroy_for_testing(clock);
        };
        test_scenario::end(scenario);
        debug::print(&win_count);
        debug::print(&lose_count);
    }
}
