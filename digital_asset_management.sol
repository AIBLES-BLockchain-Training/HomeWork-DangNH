// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract IDigitalAsset {
    function getDetails() external view virtual returns (string memory);

    function transferOwnership(address newOwner) external virtual;
}

abstract contract AbstractAsset is IDigitalAsset {
    string internal name;
    address internal owner;

    function getDetails() external view override returns (string memory) {
        return name;
    }
}

contract ArtAsset is AbstractAsset {
    string artistStageName;
    string artType;

    constructor(
        string memory _name,
        string memory _artistStageName,
        string memory _artType
    ) {
        name = _name;
        owner = msg.sender;
        artistStageName = _artistStageName;
        artType = _artType;
    }

    function transferOwnership(address newOwner) external override {
        owner = newOwner;
    }
}

contract MusicAsset is AbstractAsset {
    string artistStageName;
    string musicType;

    constructor(
        string memory _name,
        string memory _artistStageName,
        string memory _musicType
    ) {
        name = _name;
        owner = msg.sender;
        artistStageName = _artistStageName;
        musicType = _musicType;
    }

    function transferOwnership(address newOwner) external override {
        owner = newOwner;
    }
}

contract RealEstateAsset is AbstractAsset {
    uint256 area;
    string location;

    constructor(
        string memory _name,
        uint256 _area,
        string memory _location
    ) {
        name = _name;
        owner = msg.sender;
        area = _area;
        location = _location;
    }

    function transferOwnership(address newOwner) external override {
        owner = newOwner;
    }
}

contract GameItemAsset is AbstractAsset {
    uint256 attakDamage;
    uint256 defensePoint;
    string rarity;

    constructor(
        string memory _name,
        uint256 _attakDamage,
        uint256 _defensePoint,
        string memory _rarity
    ) {
        name = _name;
        owner = msg.sender;
        attakDamage = _attakDamage;
        defensePoint = _defensePoint;
        rarity = _rarity;
    }

    function transferOwnership(address newOwner) external override {
        owner = newOwner;
    }
}
