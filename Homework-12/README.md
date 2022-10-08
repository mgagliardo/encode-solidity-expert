# Homework 12

## Audit

Imagine you have been given [the following code](./DogCoinGame.sol) to audit with the following note from the team:

"DogCoinGame is a game where players are added to the contract via the addPlayer function, they need to send 1 ETH to play. Once 200 players have entered, the UI will be notified by the startPayout event, and will pick 100 winners which will be added to the winners array, the UI will then call the payout function to pay each of the winners. The remaining balance will be kept as profit for the developers."

Write out the main points that you would include in an audit report.

---

- **WARNING**: Even if players don't pay 1 ETH the `numberPlayers` variable will have +1 (meaning new players are counted even without paying).
- **OPTIMIZATION**: Change `public` to `external` as it is cheaper
- **OPTIMIZATION**: Instead of looping through 100 winers, return and array and let the winners claim its token instead on their own.
- **OPTIMIZATION**: Instead of adding the winner in an array one by one, we can think of a merkle tree. i.e. we could store it in a bytes32[] array, and `payWinner` can just verify that the winner is part of the tree and send the amount (or inform the winner).
- **CRITICAL**: There is no contract owner.
- **CRITICAL**: The `addPlayer` function will emit an event once above 200 players, meaning it will pick winners everytime.
- **CRITICAL**: `payout`, `payWinners` and `addWinner` should be restricted to the contract owner as anyone can call these functions.
- **CRITICAL**: `payWinners` should be `i < winners.length` as `<=` will generate an out of bounds error.

## Underhanded Solidity

[This contract](./BrokenSea.sol) is the winner of this years underhanded solidity contest, it mimics the
OpenSea application. Can you spot the flaws in it?

⛽🏌This is a gas-golfed version of Zora v3's Offers module!

🤩 A bidder can call createBid to bid on the NFT of their dreams.

💰 The NFT owner can call acceptBid to accept one of these on-chain bids.

🤝 Assets exchange hands.

😤 What could possibly go wrong?

### Hints

Look at the [Solmate contracts](https://github.com/transmissions11/solmate) used, and the way transferFrom is implemented

---

- An attacker could call the `acceptBid` by switching the address of the ERC721 and ERC20. The call would work:

  - XOR is commutative so we will end up with the same key
  - ERC721 of solmate `safeTransfer` and ERC20 `transfer` has the same function signature so methods will be called.

- The attacker could then get an NFT from someone already placing a bit from more or less nothing.

More info in [this talk](https://www.youtube.com/watch?v=JicU29EBaCo) from Solidity Summit '22
