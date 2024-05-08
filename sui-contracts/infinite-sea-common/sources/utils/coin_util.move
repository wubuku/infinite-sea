module infinite_sea_common::coin_util {

    use sui::balance::Balance;
    use sui::coin;
    use sui::coin::Coin;
    use sui::transfer;
    use sui::tx_context;
    use sui::tx_context::TxContext;

    #[lint_allow(self_transfer)]
    public fun split_up_and_into_balance<T>(coin: Coin<T>, amount: u64, ctx: &mut TxContext): Balance<T> {
        if (coin::value(&coin) == amount) {
            coin::into_balance(coin)
        } else {
            let s = coin::into_balance(coin::split(&mut coin, amount, ctx));
            transfer::public_transfer(coin, tx_context::sender(ctx));
            s
        }
    }
}
