// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import "./IERC6982.sol";

contract ERC721Locked is IERC6982, ERC721 {
  error TransferNotAllowed();

  constructor(string memory name, string memory symbol) ERC721(name, symbol) {
    emit DefaultLocked(true);
  }

  function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
    return
      interfaceId == type(IERC6982).interfaceId ||
      super.supportsInterface(interfaceId);
  }

  function locked(uint256) external view virtual returns (bool) {
    return true;
  }

  function defaultLocked() external view virtual returns (bool) {
    return true;
  }

  function transferFrom(address, address, uint256) public virtual override {
    revert TransferNotAllowed();
  }

  function safeTransferFrom(address, address, uint256, bytes memory) public virtual override {
    revert TransferNotAllowed();
  }
}
