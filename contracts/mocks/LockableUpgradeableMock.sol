// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

// Authors: Francesco Sullo <francesco@sullo.co>

import "../LockableUpgradeable.sol";

//import "hardhat/console.sol";

contract LockableUpgradeableMock is LockableUpgradeable {

  /// @custom:oz-upgrades-unsafe-allow constructor
  constructor() initializer {}

  function initialize(string memory name, string memory symbol) public initializer {
    __Lockable_init(name, symbol);
  }

}
