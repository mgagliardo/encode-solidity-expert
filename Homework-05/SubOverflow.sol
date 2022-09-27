// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

contract SubOverflow {
    // Modify this function so that on overflow it returns the value 0
    // otherwise it should return x - y
    function subtract(uint256 x, uint256 y) public pure returns (uint256) {
        // Write assembly code that handles overflows
        require(x > y); // Ensure x > y
        assembly {
            let result := sub(x, y) // x - y
            if lt(256, result) {
                revert(0, 0)
            }
            mstore(0x0, result) // store result in memory
            return(0x0, 256)
        }
    }
}
