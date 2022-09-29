// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.7;

contract Add {
    function run() external pure returns (uint256) {
        assembly {
            let ptr := mload(0x40) // Get next free memory pointer
            mstore(ptr, add(0x07, 0x07)) // Sum 0x07 and 0x08
            return(ptr, 32)
        }
    }
}
