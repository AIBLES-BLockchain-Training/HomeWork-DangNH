// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract IDigitalAsset {
    function getDetails() external view virtual returns (string memory);

    function transferOwnership(address newOwner) external virtual;
}

abstract contract AbstractAsset is IDigitalAsset {
    string internal name;
    address internal owner;
    
    function getDetails() external view override returns (string memory){
        return name;
    }
}

contract ArtAsset is AbstractAsset {
    constructor(string memory _name){
        name = _name;
        owner = msg.sender;
    }
    function transferOwnership(address newOwner) external override {
        
    }
}
