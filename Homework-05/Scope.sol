// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

contract Scope {
    uint256 public count = 10;

    function increment(uint256 num) public {
        // Modify state of the count variable from within
        // the assembly segment
        assembly {
            let counterMemSlot := count.slot // Get slot of count
            sstore(counterMemSlot, add(sload(counterMemSlot), num)) // Add between retrieved value and store in slot
        }
    }
}
