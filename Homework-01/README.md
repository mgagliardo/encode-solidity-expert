# Week 01 - Homework 01

## What information is held for an Ethereum account?

In case we are talking about the `account state`:

`nonce`: A scalar value equal to the number of transactions sent from this address or, in the case of accounts with associated code, the number of contract-creations made by this account.

`balance`: A scalar value equal to the number of Wei owned by this address.

`storageRoot`: A 256-bit hash of the root node of a Merkle Patricia tree that encodes the storage contents of the account (a mapping between 256-bit integer values), encoded into the trie as a mapping from the Keccak 256-bit hash of the 256-bit integer keys to the RLP-encoded 256-bit integer values.

`codeHash`: The hash of the EVM code of this account—this is the code that gets executed should this address receive a message call; it is immutable and thus, unlike all other fields, cannot be changed after construction

## Where is the full Ethereum state held?

The states are assembled into a Merkle Patricia Tree linked to the account (balance in case of EAOs and balance and storage in case of contract's account) and to the blocks.
`Physically` the states are part of the blockchain so if you have an ethereum full node you should be able to find them in the `.ethereum` folder (in a leveldb database).

For more details: <https://blog.ethereum.org/2015/06/26/state-tree-pruning>

## What is a replay attack? Which 2 pieces of information can prevent it?

Is a type of attack in which the malicious entity intercepts and then repeats a valid data transmission going through a network. Owing to the validity of the original data (which typically comes from an authorized user) the network's security protocols treat the attack as if it were a normal data transmission. The original messages are intercepted and re-transmitted verbatim. Extending this to blockchains in general, a replay attack is taking a transaction on one blockchain, and maliciously or fraudulently repeating it on another blockchain (i.e. ETH testnet vs mainnet).

The 2 pieces of information to prevent it are:

* Private keys (i.e. attackers trying to replay a Tx that uses a privatekey that does not exist or does not belong to mainnet).
* Since [EIP155](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-155md) transactions incorporate the `chainID` to the transaction signature.

## How do we know who called a view function?

Since view transactions are not saved on the blockchain, we can use [Solidity Events](https://blog.chain.link/events-and-logging-in-solidity/)
