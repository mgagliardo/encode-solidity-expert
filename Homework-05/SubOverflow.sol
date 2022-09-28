// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

contract SubOverflow {
    // Modify this function so that on overflow it returns the value 0
    // otherwise it should return x - y
    function subtract(uint256 x, uint256 y) public pure returns (uint256) {
        // Write assembly code that handles overflows
        assembly {
            let z := sub(x, y)
            let k := add(x, y)
            switch lt(z, k)
            case  true {
                mstore(0x80, z)
            }
            default {
                mstore(0x80, 0)
            }
            return(0x80, 32)
        }
    }
}
