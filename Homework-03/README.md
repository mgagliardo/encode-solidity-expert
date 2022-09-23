# Week 01 - Homework 03

## What are the advantages and disadvantages of the 256 bit word length in the EVM

The EVM having a 256-bit woed length means that it operates with fixed-width 256-bit words, when the operation result doesn't fit into 256 bits, the higher bits are just dropped, this is known as overflow. This is a "dangerous" situation, as the operation may produce a result that is mathematically incorrect.

For hardware architectures, fixed-width overflowing words is a natural decision, as operations on such words could be implemented with a fixed number of logical gates and executed in a constant number of ticks. However, hardware architectures usually provide some way to know whether overflow did happen and even to obtain extra bits that didn’t fit into the result word.

For low-level programming languages, fixed-width overflowing data types is a natural decision because they map 1:1 to underlying hardware words thus providing maximum performance.

However, as mainstream architectures nowadays are only 64-bit, EVM’s 256-bit words don’t map to hardware words and thus have any way to be implemented as big integers, i.e. software-emulated arbitrary-width words.

Taking this into account, the natural decision for EVM would be to use arbitrary width non-overflowing words rather than fixed-width overflowing ones. This would eliminate the infamous overflow problem as well as made many things much simpler.

While it is not possible to change architecture now from fixed-width to arbitrary-width words, it is still possible to introduce precompiled smart contracts for efficient big-integer operations.

## What would happen if the implementation of a precompiled contract varied between Ethereum clients?

Precompiled contracts are used in the EVM to provide more complex library functions (usually used for complex operations such as encryption, hashing, etc.) that are not suitable for writing in opcode. They are applied to contracts that are simple but frequently called, or that are logically fixed but computationally intensive. Precompiled contracts are implemented on the client-side with client code, and because they do not require the EVM, they run fast. It also costs less for developers than using functions that run directly in the EVM.

Going to the question, if the implementation of a precompiled contract varied between Ethereum clients and because precompiled contracts rely on things from outside the EVM, not all of them will be supported as they vary one each other.

For more info check these blog posts:

* <https://blog.qtum.org/precompiled-contracts-and-confidential-assets-55f2b47b231d>
* <https://medium.com/neon-labs/neon-evm-the-limitations-for-ethereum-compatibility-47d059fc1742>

## Using Remix write a simple contract that uses a memory variable, then using the debugger step through the function and inspect the memory
