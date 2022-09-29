# Week 02 - Homework 06

### Create a Solidity contract with one function. The solidity function should return the amount of ETH that was passed to it, and the function body should be written in assembly

Check code under [HW6EX1.sol](./HW6EX1.sol)

### See [gist](https://gist.github.com/extropyCoder/9ddce05801ea7ec0f357ba2d9451b2fb). Do you know what this code is doing?

It's a runtime bytecode for a contract that mutates into two child contracts and then self destructs.
The first child contract receives the call value while the second child contract recevies the remaining balance.

```
#       ┏━━━━━━━━━━━━━━━━━━━ push1 RUNTIME_BYTECODE_LEN
#       ┃   ┏━━━━━━━━━━━━━━━ dup1
#       ┃   ┃ ┏━━━━━━━━━━━━━ push1 RUNTIME_BYTECODE_OFFSET
#       ┃   ┃ ┃   ┏━━━━━━━━━ returndatasize
#       ┃   ┃ ┃   ┃ ┏━━━━━━━ codecopy
#       ┃   ┃ ┃   ┃ ┃ ┏━━━━━ returndatasize
#       ┃   ┃ ┃   ┃ ┃ ┃ ┏━━━ return
push9 0x601e8060093d393df3
#         ┗┻╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍ The only important byte that varies.
```

### Explain what the following code is doing in the Yul ERC20 contract

Returns a hash of 0x40 bytes long composed by the account (smart contract I guess?) and the spender (contract creator).

Full code is in: <https://docs.soliditylang.org/en/v0.8.16/yul.html#complete-erc20-example>

```
function allowanceStorageOffset(account, spender) -> offset {
    offset := accountToStorageOffset(account)
    mstore(0, offset)
    mstore(0x20, spender)
    offset := keccak256(0, 0x40)
}
```
