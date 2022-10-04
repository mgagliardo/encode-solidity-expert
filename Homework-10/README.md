# Homework 10

## Why are negative numbers more expensive to store than positive numbers?

- Negative number are more expensive than positive as the leftmost digit will be use to represent the sign (1 for negative and 0 for positive). Therefore, the number of bits in a number value is decreased from 256 to 255.‍

- Negative numbers are stored with a starting value of `fffff`. Which is more expensive.

## Test the following statements in Remix, which is cheaper and why? Assume that the demoninator can never be zero.

1. Answer: Costs `22.278`

```solidity
result = numerator / demoninator;
```

2. Answer: Costs `22.105`

```solidity
assembly {
    result := div(numerator, demoninator)
}
```

## For tomorrow's lesson install Foundry. See [Instructions](https://github.com/foundry-rs/foundry#installation)

1. First run the command below to get foundryup, the Foundry toolchain installer:

```shell
curl -L https://foundry.paradigm.xyz | bash
```

If you do not want to use the redirect, feel free to manually download the foundryup installation script from [here](https://raw.githubusercontent.com/foundry-rs/foundry/master/foundryup/install).
Then, run foundryup in a new terminal session or after reloading your `PATH`.
Other ways to use foundryup, and other documentation, can be found [here](https://github.com/foundry-rs/foundry/tree/master/foundryup).
