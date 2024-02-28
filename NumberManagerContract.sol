// // SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract NumberManager {
    uint256 private totalSum;
    uint256 public lastAddedNumber;

    constructor() {
        totalSum = 0;
        lastAddedNumber = 0;
    }

    function addNumber(uint256 number) public {
        totalSum += number;
        lastAddedNumber = number;
    }

    function getTotalSum() external view returns (uint256) {
        return totalSum;
    }
    
    function increaseTotalSum(uint number) private  {
        totalSum += number;
    }
}
