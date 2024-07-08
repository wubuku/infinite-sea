module infinite_sea_faucet::energy_faucet {
    use sui::balance;
    use sui::balance::Balance;
    use sui::clock;
    use sui::clock::Clock;
    use sui::coin;
    use sui::coin::Coin;
    use sui::object;
    use sui::object::UID;
    use sui::package;
    use sui::table;
    use sui::table::Table;
    use sui::transfer;
    use sui::tx_context;
    use sui::tx_context::TxContext;

    use infinite_sea_coin::energy::ENERGY;


    #[allow(unused_const)]
    const EInvalidPublisher: u64 = 50;
    const EInsufficientTimeInterval: u64 = 60;
    const EInsufficientBalance: u64 = 70;
    const A_DROP_AMOUNT: u64 = 50_000_000_000;


    struct ENERGY_FAUCET has drop {}

    struct EnergyFaucet has key, store {
        id: UID,
        balance: Balance<ENERGY>,
        grant_records: Table<address, GrantRecord>,
    }


    struct GrantRecord has store {
        amount: u64,
        grantedAt: u64
    }

    /// a "hot-potato"
    struct LoanReceipt {
        amount: u64,
    }

    fun init(otw: ENERGY_FAUCET, ctx: &mut TxContext) {
        package::claim_and_keep(otw, ctx);
        let faucet = EnergyFaucet {
            id: object::new(ctx),
            balance: balance::zero<ENERGY>(),
            grant_records: table::new(ctx),
        };
        transfer::share_object(faucet);
    }

    public entry fun request_a_drop(faucet: &mut EnergyFaucet, clock: &Clock, ctx: &mut TxContext) {
        assert!(balance::value(&faucet.balance) >= A_DROP_AMOUNT, EInsufficientBalance);
        let account_address = tx_context::sender(ctx);
        if (!table::contains(&faucet.grant_records, account_address)) {
            let grantRecord = GrantRecord {
                grantedAt: clock::timestamp_ms(clock),
                amount: A_DROP_AMOUNT,
            };
            table::add(&mut faucet.grant_records, account_address, grantRecord);
        }else {
            let grantRecord = table::borrow_mut(&mut faucet.grant_records, account_address);
            let currentTime = clock::timestamp_ms(clock);
            assert!(currentTime - grantRecord.grantedAt >= 24 * 60 * 60 * 1000, EInsufficientTimeInterval);
            grantRecord.amount = A_DROP_AMOUNT;
            grantRecord.grantedAt = currentTime;
        };
        let grant = balance::split(&mut faucet.balance, A_DROP_AMOUNT);
        transfer::public_transfer(coin::from_balance(grant, ctx), account_address);
    }

    /// Replenish
    public entry fun replenish_faucet(
        faucet: &mut EnergyFaucet,
        coin: &mut Coin<ENERGY>,
        amount: u64,
        ctx: &mut TxContext
    ) {
        assert!(balance::value(coin::balance(coin)) >= amount, EInsufficientBalance);
        let split = coin::split(coin, amount, ctx);
        balance::join(&mut faucet.balance, coin::into_balance(split));
    }

    /// Borrow a loan.
    public fun borrow_loan(
        faucet: &mut EnergyFaucet,
        amount: u64,
        _ctx: &mut TxContext
    ): (Balance<ENERGY>, LoanReceipt) {
        let loan = balance::split(&mut faucet.balance, amount);
        let amount = balance::value(&loan);
        (loan, LoanReceipt { amount })
    }

    /// Repay the loan.
    public fun repay_loan(
        faucet: &mut EnergyFaucet,
        repayment: Balance<ENERGY>,
        receipt: LoanReceipt,
        _ctx: &mut TxContext
    ) {
        let loan_amount = receipt.amount;
        assert!(loan_amount <= balance::value(&repayment), 1);
        balance::join(&mut faucet.balance, repayment);
        let LoanReceipt {
            amount: _
        } = receipt;
    }

    // ------------ tests ------------

    #[test_only]
    use std::debug;
    #[test_only]
    use sui::test_scenario;
    #[test_only]
    use sui::test_utils;

    #[allow(unused_const)]
    #[test_only]
    const TEST_ADMIN: address = @0xAD;
    #[allow(unused_const)]
    #[test_only]
    const TEST_ALICE: address = @0xA;
    #[allow(unused_const)]
    #[test_only]
    const ETestBalanceMismatch: u64 = 80;

    // ENERGY Coin Limit per Player
    #[test_only]
    const MAX_AMOUT_PER_PLAYER: u64 = 200_000_000_000;

    #[test]
    fun test_faucet() {
        let sc = test_scenario::begin(TEST_ADMIN);
        test_utils::print(b"init ...");
        {
            init(ENERGY_FAUCET {}, test_scenario::ctx(&mut sc));
        };
        {
            test_scenario::next_tx(&mut sc, TEST_ADMIN);
            let faucet = test_scenario::take_shared<EnergyFaucet>(&sc);
            test_utils::print(b"create testing balance:200000000000");
            // create test energy coin balance
            let balance_testing = balance::create_for_testing<ENERGY>(MAX_AMOUT_PER_PLAYER);
            test_utils::print(b"before join ...");
            // print balance of faucet
            debug::print(&balance::value(&faucet.balance));
            // merge test balance into the faucet
            balance::join(&mut faucet.balance, balance_testing);
            test_utils::print(b"afer join ...");
            // print balance of faucet
            debug::print(&balance::value(&faucet.balance));
            test_scenario::return_shared(faucet);
        };
        {
            test_scenario::next_tx(&mut sc, TEST_ALICE);
            let faucet = test_scenario::take_shared<EnergyFaucet>(&sc);
            // create the clock object, and the time is 0
            let clock = clock::create_for_testing(test_scenario::ctx(&mut sc));
            // request faucet for the first time
            test_utils::print(b"request faucet first time ...");
            request_a_drop(&mut faucet, &clock, test_scenario::ctx(&mut sc));
            test_utils::print(b"after first time request ...");
            debug::print(&balance::value(&faucet.balance));
            test_utils::print(b"request again ...");
            // assume that exactly one day has passed
            clock::set_for_testing(&mut clock, 24 * 60 * 60 * 1000);
            request_a_drop(&mut faucet, &clock, test_scenario::ctx(&mut sc));
            test_utils::print(b"after second time request ...");
            debug::print(&balance::value(&faucet.balance));
            clock::destroy_for_testing(clock);
            test_scenario::return_shared(faucet);
        };
        {
            test_scenario::next_tx(&mut sc, TEST_ALICE);
            let energy = test_scenario::take_from_sender<Coin<ENERGY>>(&sc);
            test_utils::print(b"Alice's ENERGY coin amount:");
            debug::print(&balance::value(coin::balance(&energy)));
            assert!(balance::value(coin::balance(&energy)) == A_DROP_AMOUNT, ETestBalanceMismatch);
            test_scenario::return_to_sender(&sc, energy);
        };
        test_scenario::end(sc);
    }


    // #[test]
    // public entry fun borrow_arbitrage_repay_template_(faucet: &mut EnergyFaucet, ctx: &mut TxContext) {
    //     let borrow_amount = 100_000_000_000_000;
    //     let (loan, receipt) = borrow_loan(faucet, borrow_amount, ctx);
    //
    //     //
    //     // TODO arbitrage...
    //     let b = loan; // <- This is a placeholder for the arbitrage logic.
    //     //
    //
    //     let repayment = balance::split(&mut b, borrow_amount);
    //     let profit = coin::zero<ENERGY>(ctx);
    //     coin::join(&mut profit, coin::from_balance(b, ctx));
    //     transfer::public_transfer(profit, tx_context::sender(ctx));
    //
    //     repay_loan(faucet, repayment, receipt, ctx);
    // }
}
