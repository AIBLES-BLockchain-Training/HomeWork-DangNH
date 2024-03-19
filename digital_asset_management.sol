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
        initialize(_name, _artistStageName, _artType);
    }

    function initialize(string memory _name, string memory _artistStageName, string memory _artType) public {
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
        initialize(_name, _artistStageName, _musicType);
    }

    function initialize(string memory _name, string memory _artistStageName, string memory _musicType) public {
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
        initialize(_name, _area, _location);
    }

    function initialize(string memory _name, uint256 _area, string memory _location) public {
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
        initialize(_name, _attakDamage, _defensePoint, _rarity);
    }

    function initialize(string memory _name, uint256 _attakDamage, uint256 _defensePoint, string memory _rarity) public {
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

// https://docs.google.com/document/d/1-ipYtNW8wjrImkZcJH25VTAy25h01OrNezT3UNeYgko/edit?usp=sharing
contract CloneFactory {

    function createClone(address target) internal returns (address result) {
        bytes20 targetBytes = bytes20(target);
        assembly {
          let clone := mload(0x40)
          mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
          mstore(add(clone, 0x14), targetBytes)
          mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
          result := create(0, clone, 0x37)
        }
  }

  function isClone(address target, address query) internal view returns (bool result) {
        bytes20 targetBytes = bytes20(target);
        assembly {
            let clone := mload(0x40)
            mstore(clone, 0x363d3d373d3d3d363d7300000000000000000000000000000000000000000000)
            mstore(add(clone, 0xa), targetBytes)
            mstore(add(clone, 0x1e), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)

            let other := add(clone, 0x40)
            extcodecopy(query, other, 0, 0x2d)
            result := and(
                eq(mload(clone), mload(other)),
                eq(mload(add(clone, 0xd)), mload(add(other, 0xd)))
            )
        }
  }
}

contract CloneAssetFactory is CloneFactory {
    AbstractAsset[] public assets;

    function createArtAsset(address originalArtAsset, string memory name, string memory _artistStageName, string memory _artType) external returns(uint) {
        ArtAsset asset = ArtAsset(createClone(originalArtAsset));
        asset.initialize(name, _artistStageName, _artType);
        assets.push(asset);
        return assets.length - 1;
    }

    function createMusicAsset(address originalMusicAsset, string memory name, string memory _artistStageName, string memory _musicType) external returns(uint) {
        MusicAsset asset = MusicAsset(createClone(originalMusicAsset));
        asset.initialize(name, _artistStageName, _musicType);
        assets.push(asset);
        return assets.length - 1;
    }

    function createRealEstateAsset(address originalRealEstateAsset, string memory name, uint256 _area, string memory _location) external returns(uint) {
        RealEstateAsset asset = RealEstateAsset(createClone(originalRealEstateAsset));
        asset.initialize(name, _area, _location);
        assets.push(asset);
        return assets.length - 1;
    }

    function createGameAsset(address originalGameAsset, string memory name, uint256 _attakDamage, uint256 _defensePoint, string memory _rarity) external returns(uint) {
        GameItemAsset asset = GameItemAsset(createClone(originalGameAsset));
        asset.initialize(name, _attakDamage, _defensePoint, _rarity);
        assets.push(asset);
        return assets.length - 1;
    }

    function getAbstractAssets() external view returns(AbstractAsset[] memory) {
        return assets;
    }
}