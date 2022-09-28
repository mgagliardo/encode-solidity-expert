// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

contract HW6EX1 {
    function sendETH() external payable returns (uint256) {
        assembly {
            let amount := callvalue()
            mstore(0x80, amount)
            return(0x80, 32)
        }
    }
}
