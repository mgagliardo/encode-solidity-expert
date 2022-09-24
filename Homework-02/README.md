# Homework 2

## Try out the Solidity Template

### Start a new project using the Solidity Template

Check the current folder for details

### Make a fork of mainnet from the command line (you may need to setup an Infura or Alchemy account)

```
$ npx hardhat node --fork https://mainnet.infura.io/v3/<INFURA_ID>
```

### Query the mainnet using the command line to retrieve a property such as latest block number.

Example command. Use `latest` to get the last block using `JSON-RPC`:

```
$ curl -s -X POST --data '{"jsonrpc":"2.0","method":"eth_getBlockByNumber","params":["latest", false],"id":1}' localhost:8545  | jq
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": {
    "number": "0xee1e6f",
    "hash": "0xe816f0333f20c22d8896eddb53a1888f220b68addeda3be9fe3bc65ddef5c4d9",
    "parentHash": "0x99e03776dc189fbebc5ec8dff7f404cb8a3ae87e50eeca28ff08ba4187e2e9a8",
    "nonce": "0x0000000000000000",
    "mixHash": "0x27f2def8d93dfaf91b65432d0ab178f6ca32d64439cce512152bb8b13c8f47d4",
    "sha3Uncles": "0x1dcc4de8dec75d7aab85b567b6ccd41ad312451b948a7413f0a142fd40d49347",
    "logsBloom": "0xc02220200100003080012201800010602820003004800400010100002c9444002000200000216620801228a8000324010204004008002020010400020024208002002000124a0208281000080000002804000000104c080a212040008820000002400080020241020140300212000c00011a100006410402001004100008806800200500300a1000004c00000090020000002003010480088000804000000081ae100900427468080400000070802080920401212024010300200502010a00480100000385090000000020000000100000180040000a001a00000922002164000010b008000200000002100c81100806c0100600010c094000000840000ac001",
    "transactionsRoot": "0x3692fa27cf3a01ae308639055f04a1b91e076504221afbdb4a47c74521a747c4",
    "stateRoot": "0x8c55e96acab54e5f286df157de0350949629e1a64125f2a58d68bea4a57a36e3",
    "receiptsRoot": "0xc4f08bb7d4585b1cd464ae9306fdc8ca4d03182030a4a7c9509169efeaa33460",
    "miner": "0x4675c7e5baafbffbca748158becba61ef3b0a263",
    "difficulty": "0x0",
    "totalDifficulty": "0xc70d815d562d3cfa955",
    "extraData": "0x",
    "size": "0x22dd",
    "gasLimit": "0x1c9c380",
    "gasUsed": "0x1e9924",
    "timestamp": "0x632f5cdf",
    "transactions": [
      "0xa55c5cd0e6491b856594c1d7713c7890184a3572455a193e5ef93c1a511a8c0d",
      "0x1d9a09f5696dc28da54c7ff24568c86071078d29d310dab3a30f83cfd92d9a60",
      "0x3bf1216bae57ff7da8abd983b325c757b75211366c8f6515bd8920c956afac68",
      "0xccab8a824c25513d59f57340a85064bbbe0a7d1be7ae1c48ada15125d964d7f0",
      "0xb6b9204cdec8bb865e16c6d74462236ae8032b3f16dddabb226aa5d867b141a4",
      "0x4bffb322c328a9cec9791319924c0a57c0dc18308f2886f2cff164a87145ade3",
      "0xfae08c058b86c435a395ee51797617c963d4f0c905f767e3a2badf4fb5552527",
      "0x61b6fd74d8345288fd989d1c9ac854457ca67acd29682f382e700b3de1aedead",
      "0x71fba9ded2a2a868e1f75b43b6264b8d398d5e9d9eb10b1f942ef6accf4bb841",
      "0x3e20d12de2a27cdf916777c1c7945602beac06ffbbc167c840eb714ed38a5d92",
      "0x04f563655c4b1b3c7937549c4e6ffc1cf5251d6ff793fa806c0e70067024bdac",
      "0xb998b9acad8ee285b1b43af0903b07a2d6616006262a7b32910976e2246c51bf",
      "0xed15ea4895b20f57b0652528cccb1e99039a4fe990ac8283702ec5fa305241d8",
      "0x8a0b0f997e2ea7a8cb7c0ae8c4f458d1ddeda42bb3d9ad564f78a96fd81d304e",
      "0x844bf4bf09850a3a7821dbe908a6b3bcd7f57ed105c92bfce94edce47a093f6c",
      "0x68828a20d1ac120894792826d3db98925fe73349126472c410dd23b413511873",
      "0x4f673233f05b4a40e6a007dc971bb1137ebd18e74991caaa002372ceb571a825",
      "0xe8c6617645d610c14d908fa5f48fc71a3eb83a62a18a8d54a89b2c20d69d9bb0",
      "0xee277363f3b2dba59f60e16e08dc37b244300a5debc8895557020619704e5a5a",
      "0x56eb668317e27de111a7716cadf12448b258f4a1450bf421f9226e66c400a8ec",
      "0x51e80489cd31a38d71d04c8b4be059f794f7bf4709d585fab8ae47f10142bc55"
    ],
    "uncles": [],
    "baseFeePerGas": "0xe1281b50"
  }
}
```

## Solidity

### Write a function that will delete items (one at a time) from a dynamic array without leaving gaps in the array. You should assume that the items to be deleted are chosen at random, and try to do this in a gas efficient manner. For example imagine your array has 12 items and you need to delete the items at indexes 8, 2 and 7.

### The final array will then have items {0,1,3,4,5,6,9,10,11}

You can find the contract under [DynamicArrayItemsRemover.sol](./contracts/DynamicArrayItemsRemover.sol)
