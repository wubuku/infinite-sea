module infinite_sea_coin::energy_faucet {
    use sui::balance;
    use sui::balance::Balance;
    use sui::coin;
    use sui::coin::Coin;
    use sui::object;
    use sui::object::UID;
    use sui::transfer;
    use sui::transfer::public_transfer;
    use sui::tx_context::{sender, TxContext};

    use infinite_sea_coin::energy::ENERGY;

    const A_DROP_AMOUNT: u64 = 100_000_000_000;

    /// a "hot-potato"
    struct LoanReceipt {
        amount: u64,
    }

    struct EnergyFaucet has key, store {
        id: UID,
        balance: Balance<ENERGY>,
    }

    public entry fun create_faucet(coin: &mut Coin<ENERGY>, amount: u64, ctx: &mut TxContext) {
        let faucet = EnergyFaucet {
            id: object::new(ctx),
            balance: coin::into_balance(coin::split(coin, amount, ctx)),
        };
        transfer::share_object(faucet)
    }

    public entry fun request_a_drop(faucet: &mut EnergyFaucet, ctx: &mut TxContext) {
        let b = balance::split(&mut faucet.balance, A_DROP_AMOUNT);
        public_transfer(coin::from_balance(b, ctx), sender(ctx))
    }

    /// Replenish
    public entry fun replenish_faucet(
        faucet: &mut EnergyFaucet,
        coin: &mut Coin<ENERGY>,
        amount: u64,
        ctx: &mut TxContext
    ) {
        balance::join(&mut faucet.balance, coin::into_balance(coin::split(coin, amount, ctx)));
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

    #[test]
    public entry fun borrow_arbitrage_repay_template_(faucet: &mut EnergyFaucet, ctx: &mut TxContext) {
        let borrow_amount = 100_000_000_000_000;
        let (loan, receipt) = borrow_loan(faucet, borrow_amount, ctx);

        //
        // TODO arbitrage...
        let b = loan; // <- This is a placeholder for the arbitrage logic.
        //

        let repayment = balance::split(&mut b, borrow_amount);
        let profit = coin::zero<ENERGY>(ctx);
        coin::join(&mut profit, coin::from_balance(b, ctx));
        public_transfer(profit, sender(ctx));

        repay_loan(faucet, repayment, receipt, ctx);
    }
}
