# Homework 11

## Read our background [article to MEV](https://extropy-io.medium.com/illuminating-the-dark-forest-748d915eeaa1)

## Read the accounts of MEV attacks

* <https://www.paradigm.xyz/2020/08/ethereum-is-a-dark-forest/>
* <https://samczsun.com/escaping-the-dark-forest/>

## Discuss in your teams how you can mitigate MEV, and should we do so?

* Have a third party which is ordering the TX (not incentivized based on tip or auction). MEV is only possible because miners are choosing the TXs.
* Mempool as FIFO queue?
* re: Sandwitch attack, reduce the slippage allowed

In any case, MEV should not be mitigated has it is an important part of the Eth ecosystem. Whitout MEV:

* There would be no DeFi (no one would leave their funds to Protocol like AAVE, if the borrower could not be liquidated after being under-collateralized)
* MEV and projects like flashbots allowed mining activity to remain sustainable. Without it, we could see a concentration of miners mining a higher risk of bandit attack.

## Look through the code for the [MEV bot Sandwich contract](./Sandwich.sol). Do you understand what the assembly code is doing?

The contract is just composed by a fallback that does the frontslice and backslice of the sandwich by sending an X amount of ERC20 token to the pair uniswap address and swapping it for an amount Y. The backslice will just do the same but in the other direction.

The code is fully realized in YUL which allows some optimization like the non SSTORE of the owner by pushing it at the end of the code bytecode (datacopy).

The rest of the package is the bot, which is written in js:

* Reading from the mempool and filtering only the swapExactETHForToken
* Getting the right amountOut to swap (front)
* Checking profitability
* Creating the bundle
* Calling flashbots

## Discuss in your teams what should have been done differently to prevent the Nomad hack

* It looks like the confirmed root was only added into a map (root => timestamp). This alone was enough to prove that the root was ok. The root was not reproven against the Merkle Tree.
* Check that the message passed in not 0x0
* Have a map on the root already executed (this could have limit to on malicious tx using this attack vector)
* Improved unit testing (fuzzing?)
