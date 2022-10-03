# Homework 9

## How can the use of `tx.origin` in a contract be exploited?

`tx.origin` is a `global variable` in Solidity which returns the address of the account that sent the transaction. Contracts that use the `tx.origin` to authorize users are vulnerable to phishing attacks.

Let’s say a call could be made to the vulnerable contract that passes the authorization check since `tx.origin` returns the original sender of the transaction which in this case is the authorized account.

For example:

```solidity
contract Wallet {
    address public owner;

    constructor() payable {
        owner = msg.sender;
    }

    function transfer(address payable _to, uint _amount) public {
        require(tx.origin == owner);

        (bool sent, ) = _to.call{value: _amount}("");
        require(sent, "Failed to send Ether");
    }
}

contract Attack {
    address payable public owner;
    Wallet wallet;

    constructor(Wallet _wallet) {
        wallet = Wallet(_wallet);
        owner = payable(msg.sender);
    }

    function attack() public {
        wallet.transfer(owner, address(wallet).balance);
    }
}
```

There are 2 contracts here: A `Wallet` that stores and withdraws funds that authorizes the transfer function using `tx.origin`, and an `Attack` contract which is a contract made by an attacker who wants to attack the first contract.

If the owner of the `Wallet` contract sends a transaction with enough gas to the `Attack` address, it will invoke the fallback function, which in turn calls the transfer function of the `Wallet` contract with the parameter attacker.

As a result, all funds from the `Wallet` contract will be withdrawn to the attacker's address. This is because the address that first initialized the call was the victim (the owner of the `Wallet` contract).

Therefore, `tx.origin` will be equal to the owner and the require on will pass.

## What do you understand by event spoofing?

`Spoofing` is the act of disguising a communication from an unknown source as being from a known, trusted source.

A spoofing event (as I understand it) happens when a data source that sends event updates, triggers a smart contract to execute when they shouldn't.

Example of this event: <https://cryptoslate.com/seeming-oracle-attack-causes-100m-in-ethereum-defi-liquidations/>

## What problems can you find in [this contract](./Example1.sol) designed to produce a random number

As defined on the [best practices guideline](https://consensys.github.io/smart-contract-best-practices/development-recommendations/solidity-specific/timestamp-dependence/#timestamp-manipulation), it is a risk to have a dependency on timestamps of the block as it can be manipulated by a miner.

When the contract uses the timestamp to seed a random number, the miner can actually post a timestamp within 15 seconds of the block being validated, effectively allowing the miner to precompute an option more favorable for them.

`Timestamps` are not random and should not be used in that context.

## What problems are there in [this contract](./Example2.sol)?

- `joinCourse()` is public, meaning anyone can join the course. A potential fix would be make the joinCourse only accessible by the admin/whitelist.

- This code is vulnerable to a DoS attack as anyone could add an entry in the students array, welcomeStudents() might be very expensive to call due to the for loop. A potential fix would be calling welcomeStudents with just the new student all in once, also add a functionality to remove students by an admin to flush the array for every course.
