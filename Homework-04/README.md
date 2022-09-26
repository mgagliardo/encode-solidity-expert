# Week 02 - Homework 04

### Look at the example of init code in today's notes. [See gist](https://gist.github.com/extropyCoder/4243c0f90e6a6e97006a31f5b9265b94). When we do the CODECOPY operation, what are we overwriting? (debugging this in Remix might help here)

### Could the answer to Q1 allow an optimisation?

### Can you trigger a revert in the init code in Remix?

### Write some Yul to

1. Add 0x07 to 0x08
2. store the result at the next free memory location.
3. (optional) write this again in opcodes

### Can you think of a situation where the opcode EXTCODECOPY is used?

The Yellow Paper mentions an EVM opcode EXTCODECOPY which copies an account's code to memory, so one usecase for `EXTCODECOPY` is to access the code of a contract from another contract.

The following example provides library code to access the code of another contract and load it into a bytes variable. This is not possible at all with "plain Solidity" and the idea is that assembly libraries will be used to enhance the language in such ways.

The following example provides library code to access the code of another contract and load it into a bytes variable. This is possible with “plain Solidity” too, by using <address>.code. But the point here is that reusable assembly libraries can enhance the Solidity language without a compiler change.

```
library GetCode {
  function at(address _addr) returns (bytes o_code) {
    assembly {
      // retrieve the size of the code, this needs assembly
      let size := extcodesize(_addr)
      // allocate output byte array - this could also be done without assembly
      // by using o_code = new bytes(size)
      o_code := mload(0x40)
      // new "memory end" including padding
      mstore(0x40, add(o_code, and(add(add(size, 0x20), 0x1f), bnot(0x1f))))
      // store length in memory
      mstore(o_code, size)
      // actually retrieve the code, this needs assembly
      extcodecopy(_addr, add(o_code, 0x20), 0, size)
    }
  }
}
```
