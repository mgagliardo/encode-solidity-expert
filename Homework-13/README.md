# Homework 13

Investigate [this project](https://github.com/ExtropyIO/ExpertSolidityBootcamp/tree/main/exercises/defiFoundry)

Imagine you have been given the `DeFi1` contract by a colleague and asked to test it using Foundry.

Your colleague explains that the contract allows:

- Investors to be added by the administrator
- Investors to claim tokens, but the amount that they can claim should reduce every 1000 blocks.

When testing make sure you know:

- How would you advance blocks
- How would you make sure every block will work
- How would you make sure the contract works with different starting values such as:
  - Block reward,
  - Numbers of investors
  - Initial number of tokens
  
Try to find all the bugs / security problems / optimisation opportunities in the contract.

You do not need to fix the code.

---

## Errors

1. Wrong initialization of `initialBalance`:

    ```sol
    function testInitialBalance() public {
        defi.addInvestor(address(alice));
        vm.startPrank(address(alice));
        vm.roll(1);
        uint256 payoutAmount = defi.calculatePayout();
        defi.claimTokens();
        uint256 aliceBalance = token.balanceOf(address(alice));
        assertEq(aliceBalance, payoutAmount);
    }
    ```

1. Payout never set given to no token transfer.

## Optimizations

1. `claimTokens` can be external, giving

1. When no investors, `calculatePayout` will divide by 0 in line 45:

    ```sol
        payout = initialAmount / investors.length;
    ```

    The following test fails:

    ```sol
        function testDivideByZeroWhenNoInvestors() public {
            vm.prank(vm.addr(1));
            uint256 payoutAmount = defi.calculatePayout();
            assert(payoutAmount == 0);
        }
    ```

1. If `initialAmount = 0` then no token are given to the contract and thus transfers will fail.

    ```sol
        function testCalculatePayoutOver1000BlocksFails() public {
            defi.addInvestor(address(alice));
            vm.prank(address(alice));
            vm.roll(1000);
            uint256 payoutAmount = defi.calculatePayout();
        }
    ```

1. `claimTokens` can be simplified and optimized by looping and then sending the transfer if it finds the investor:

    ```sol
        function claimTokens() public {
            for (uint256 ii = 0; ii < investors.length; ii++) {
                if (investors[ii] == msg.sender) {
                    token.transfer(msg.sender, calculatePayout());
                    return;
                }
            }
        }
    ```

1. `blockReward` is used many times inside `calculatePayout` and it has the same name as the declared variable in the initialization of the contract, should be changed for code simplification

## Security Problems

1. `addInvestor` can be called by anyone, not just the administrator. There is a missing check.

    ```sol
    function testAnyoneCanAddAnInvestor() public {
        vm.expectRevert();
        vm.prank(vm.addr(1));
        defi.addInvestor(vm.addr(2));
    }
    ```

1. `calculatePayout` should be restricted to `view`

Full code for this excercise is [here](./Contract.t.sol)
