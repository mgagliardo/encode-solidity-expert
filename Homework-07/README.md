# Week 02 - Homework 07

## Gas Optimisation team game

Follow the instructions for the gas optimisation team game in the [repo](https://github.com/ExtropyIO/ExpertSolidityBootcamp/tree/ad4c07cff15b50f05a3827dfed9d35c45e38b625/exercises/gas) Your team should try to reduce the amount of gas used to deploy the contract, and when running transactions. You can change the code as much as you like, but you must not change the tests, and your contract must pass all tests.

## Optimisation Game Instructions

1. Open a terminal go to the Gas directory
2. Run `npm i` to install the dependencies
3. Run `npx hardhat test` to run the tests and get a gas usage report

![test run](https://i.imgur.com/qdNy92B.png)

If you prefer to use a different IDE, you may, but you will need to make sure the contract passes the same tests.

The aim of the game is to reduce the Average figures for contract deployment and transfer and updatePayment functions as much as possible.

You can change the contract as much as you like.
You **cannot**  change the tests, and all the tests must pass.

you can slightly adjust tests for whitelist functions if you need so.

In order to generate storage diagram run the following command:

`sol2uml storage ./contracts/ -c GasContract -o gasStorage.svg`
