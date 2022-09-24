// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

contract DynamicArrayItemsRemover {

    // Bootstrap the example array
    uint[] array = [0,1,2,3,4,5,6,7,8,9,10,11];

    function removeItems(uint index) external returns(uint[] memory) {
        require(index < array.length, "Out of range");

        // If array still has elements to move
        // Else we just pop the last element
        if (array.length > 1) {
            // As we want an ordered array we need to go into it using a for loop
            // Start from chosen index to maximize use of gas
            for (uint i = index; i < array.length - 1; i++){
                array[i] = array[i + 1];
            }
        }
        array.pop();
        return array;
    }

    function getArray() external view returns(uint[] memory) {
        return array;
    }
}
