// SPDX-License-Identifier: GPL3
pragma solidity ^0.8.9;

import "../ERC721Locked.sol";

contract MyERC721Locked is ERC721Locked {
  constructor() ERC721Locked("My ERC721Locked Token", "MST") {
    emit DefaultLocked(true);
  }
}
