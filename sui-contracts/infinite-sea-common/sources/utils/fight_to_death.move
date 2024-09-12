module infinite_sea_common::fight_to_death {

    use std::vector;

    use sui::clock::Clock;

    use infinite_sea_common::ts_random_util;

    const EInvalidSelfHealth: u64 = 1;
    const EInvalidOpponentHealth: u64 = 2;
    const EBothAlive: u64 = 3;
    const EBothDead: u64 = 4;

    public fun perform(
        clock: &Clock,
        seed: vector<u8>,
        self_attack: u32,
        self_protection: u32,
        self_health: u32,
        opponent_attack: u32,
        opponent_protection: u32,
        opponent_health: u32,
    ): (u32, u32) {
        assert!(self_health > 0, EInvalidSelfHealth);
        assert!(opponent_health > 0, EInvalidOpponentHealth);
        if (self_health == 1 && opponent_health > 2
            || opponent_health == 1 && self_health > 2
        ) {
            return (1, 1)
        };
        let self_damage_probabilities: vector<u32> = vector::empty<u32>();//vector[25, 50, 75, 100];
        let opponent_damage_probabilities: vector<u32> = vector::empty<u32>();//vector[25, 50, 75, 100];
        let self_damage_delta_right_shift = false;
        let opponent_damage_delta_right_shift = false;
        let (self_damage_numerator, self_damage_denominator) = if (self_health * 3 <= opponent_health) {
            (100, 100)
        }
        else if (self_protection * 2 <= opponent_attack || self_protection + 2 <= opponent_attack || (self_health * 3 <= opponent_health * 2 || self_health + 5 <= opponent_health)) {
            (90, 100)
        } else {
            (if (opponent_attack > self_protection) { opponent_attack - self_protection } else {
                self_damage_delta_right_shift = true;
                self_protection - opponent_attack
            }, self_protection)
        };

        let (opponent_damage_numerator, opponent_damage_denominator) = if (opponent_health * 3 <= self_health) {
            (100, 100)
        }  else if (opponent_protection * 2 <= self_attack || opponent_protection + 2 <= self_attack || (opponent_health * 3 <= self_health * 2 || opponent_health + 5 <= self_health)) {
            (90, 100)
        } else {
            (if (self_attack > opponent_protection) { self_attack - opponent_protection } else {
                opponent_damage_delta_right_shift = true;
                opponent_protection - self_attack
            }, opponent_protection)
        };
        let scaling_factor = 10_000;
        self_damage_numerator = self_damage_numerator * scaling_factor;
        self_damage_denominator = self_damage_denominator * scaling_factor;
        opponent_damage_numerator = opponent_damage_numerator * scaling_factor;
        opponent_damage_denominator = opponent_damage_denominator * scaling_factor;
        if (self_damage_delta_right_shift) {
            // The greater your HP (relative to the opponent), the less damage you take.
            // -- (Lower damage range) right shift more -->
            self_damage_numerator = self_damage_numerator + (self_damage_denominator - self_damage_numerator) * self_health / (self_health + opponent_health);
        } else {
            // The less opponent's HP (relative to yours), the less damage you take.
            // <-- (Higher damage range) Left shift less  --
            self_damage_numerator = self_damage_numerator * opponent_health / (self_health + opponent_health);
        };
        if (opponent_damage_delta_right_shift) {
            opponent_damage_numerator = opponent_damage_numerator + (opponent_damage_denominator - opponent_damage_numerator) * opponent_health / (self_health + opponent_health);
        } else {
            opponent_damage_numerator = opponent_damage_numerator * self_health / (self_health + opponent_health);
        };
        let self_damage_delta = 25 * self_damage_numerator / self_damage_denominator;
        let opponent_damage_delta = 25 * opponent_damage_numerator / opponent_damage_denominator;
        if (self_damage_delta_right_shift) {
            vector::push_back(&mut self_damage_probabilities, 25 + self_damage_delta);
            vector::push_back(&mut self_damage_probabilities, 50 + self_damage_delta * 2);
            vector::push_back(&mut self_damage_probabilities, 75 + self_damage_delta);
            vector::push_back(&mut self_damage_probabilities, 100);
        } else {
            vector::push_back(&mut self_damage_probabilities, 25 - self_damage_delta);
            vector::push_back(&mut self_damage_probabilities, 50 - self_damage_delta * 2);
            vector::push_back(&mut self_damage_probabilities, 75 - self_damage_delta * 3);
            vector::push_back(&mut self_damage_probabilities, 100);
        };
        if (opponent_damage_delta_right_shift) {
            vector::push_back(&mut opponent_damage_probabilities, 25 + opponent_damage_delta);
            vector::push_back(&mut opponent_damage_probabilities, 50 + opponent_damage_delta * 2);
            vector::push_back(&mut opponent_damage_probabilities, 75 + opponent_damage_delta);
            vector::push_back(&mut opponent_damage_probabilities, 100);
        } else {
            vector::push_back(&mut opponent_damage_probabilities, 25 - opponent_damage_delta);
            vector::push_back(&mut opponent_damage_probabilities, 50 - opponent_damage_delta * 2);
            vector::push_back(&mut opponent_damage_probabilities, 75 - opponent_damage_delta * 3);
            vector::push_back(&mut opponent_damage_probabilities, 100);
        };

        let (random_1, _, random_3, random_2) = ts_random_util::get_4_u64(clock, seed);
        random_1 = random_1 % 100;
        random_2 = random_2 % 100;

        let self_damage_taken = 0;
        let opponent_damage_taken = 0;

        let i = 0;
        while (i < 4) {
            if ((random_1 as u32) < *vector::borrow(&self_damage_probabilities, i)) {
                self_damage_taken = self_health * 25 * ((i as u32) + 1) / 100;
                break
            };
            i = i + 1;
        };
        let i = 0;
        while (i < 4) {
            if ((random_2 as u32) < *vector::borrow(&opponent_damage_probabilities, i)) {
                opponent_damage_taken = opponent_health * 25 * ((i as u32) + 1) / 100;
                break
            };
            i = i + 1;
        };
        if (self_damage_taken != self_health && opponent_damage_taken != opponent_health) {
            // One must die
            let self_damage_taken_x = self_damage_taken * opponent_health;
            let opponent_damage_taken_x = opponent_damage_taken * self_health;
            if (self_damage_taken_x > opponent_damage_taken_x) {
                self_damage_taken = self_health;
            } else if (self_damage_taken_x == opponent_damage_taken_x && random_3 % 2 == 0) {
                self_damage_taken = self_health;
            } else {
                opponent_damage_taken = opponent_health;
            };
        } else if (self_damage_taken == self_health && opponent_damage_taken == opponent_health) {
            if (self_damage_taken < opponent_damage_taken) {
                self_damage_taken = self_health - 1;
            } else if (self_damage_taken == opponent_damage_taken && random_3 % 2 == 1) {
                self_damage_taken = self_health - 1;
            } else {
                opponent_damage_taken = opponent_health - 1;
            };
        };
        // paranoid check:
        assert!(!(self_damage_taken == self_health && opponent_damage_taken == opponent_health), EBothDead);
        assert!(!(self_damage_taken != self_health && opponent_damage_taken != opponent_health), EBothAlive);
        (self_damage_taken, opponent_damage_taken)
    }
}


