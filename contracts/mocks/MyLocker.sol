// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

// Authors: Francesco Sullo <francesco@sullo.co>

import "../IERC721Lockable.sol";

contract MyLocker {

  function lock(address asset, uint id) public {
    IERC721Lockable(asset).lock(id);
  }

  function unlock(address asset, uint id) public {
    IERC721Lockable(asset).unlock(id);
  }
}
