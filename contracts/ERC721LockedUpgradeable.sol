// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "./IERC6982.sol";

contract ERC721LockedUpgradeable is IERC6982, Initializable, ERC721Upgradeable {
  error TransferNotAllowed();

  // solhint-disable-next-line func-name-mixedcase
  function __ERC721Locked_init(string memory name_, string memory symbol_) internal onlyInitializing {
    __ERC721_init(name_, symbol_);
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
