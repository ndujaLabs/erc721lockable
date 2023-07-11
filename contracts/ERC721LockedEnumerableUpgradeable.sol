// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";

import "./IERC6982.sol";

contract ERC721LockedEnumerableUpgradeable is IERC6982, Initializable, ERC721Upgradeable, ERC721EnumerableUpgradeable {
  error TransferNotAllowed();

  // solhint-disable-next-line func-name-mixedcase
  function __ERC721Locked_init(string memory name_, string memory symbol_) internal onlyInitializing {
    __ERC721_init(name_, symbol_);
    emit DefaultLocked(true);
  }

  function supportsInterface(
    bytes4 interfaceId
  ) public view virtual override(ERC721Upgradeable, ERC721EnumerableUpgradeable) returns (bool) {
    return interfaceId == type(IERC6982).interfaceId || super.supportsInterface(interfaceId);
  }

  function _beforeTokenTransfer(
    address from,
    address to,
    uint256 tokenId,
    uint256 batchSize
  ) internal virtual override(ERC721Upgradeable, ERC721EnumerableUpgradeable) {}

  function locked(uint256) external view virtual returns (bool) {
    return true;
  }

  function defaultLocked() external view virtual returns (bool) {
    return true;
  }

  function transferFrom(address, address, uint256) public virtual override(IERC721Upgradeable, ERC721Upgradeable) {
    revert TransferNotAllowed();
  }

  function safeTransferFrom(
    address,
    address,
    uint256,
    bytes memory
  ) public virtual override(IERC721Upgradeable, ERC721Upgradeable) {
    revert TransferNotAllowed();
  }
}
