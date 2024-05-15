module infinite_sea_coin::energy_faucet {
    use sui::balance;
    use sui::balance::Balance;
    use sui::coin;
    use sui::coin::Coin;
    use sui::object;
    use sui::object::UID;
    use sui::transfer;
    use sui::transfer::transfer;
    use sui::tx_context::{sender, TxContext};

    use infinite_sea_coin::energy::ENERGY;

    const DROP_AMOUNT: u64 = 100_000_000_000;

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
        let b = balance::split(&mut faucet.balance, DROP_AMOUNT);
        transfer(coin::from_balance(b, ctx), sender(ctx))
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
}
