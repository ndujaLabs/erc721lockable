// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

// Authors: Francesco Sullo <francesco@sullo.co>

import "../ERC721LockableUpgradeable.sol";

//import "hardhat/console.sol";

contract ERC721LockableUpgradeableMock is ERC721LockableUpgradeable {

  /// @custom:oz-upgrades-unsafe-allow constructor
  constructor() initializer {}

  function initialize(string memory name, string memory symbol) public initializer {
    __ERC721Lockable_init(name, symbol);
  }

}
