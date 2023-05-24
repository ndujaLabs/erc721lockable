// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "./IERC721DefaultApprovable.sol";
import "./IERC6982.sol";

contract ERC721LockedUpgradeable is IERC6982, IERC721DefaultApprovable, Initializable, ERC721Upgradeable {
  error ApprovalNotAllowed();
  error TransferNotAllowed();

  // solhint-disable-next-line func-name-mixedcase
  function __ERC721Locked_init(string memory name_, string memory symbol_) internal onlyInitializing {
    __ERC721_init(name_, symbol_);
    emit DefaultApprovable(false);
    emit DefaultLocked(true);
  }

  function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
    return
      interfaceId == type(IERC721DefaultApprovable).interfaceId ||
      interfaceId == type(IERC6982).interfaceId ||
      super.supportsInterface(interfaceId);
  }

  function approvable(uint256) external view virtual returns (bool) {
    return false;
  }

  function locked(uint256) external view virtual returns (bool) {
    return true;
  }

  function defaultLocked() external view virtual returns (bool) {
    return true;
  }

  function approve(address, uint256) public virtual override {
    revert ApprovalNotAllowed();
  }

  function getApproved(uint256) public view virtual override returns (address) {
    return address(0);
  }

  function setApprovalForAll(address, bool) public virtual override {
    revert ApprovalNotAllowed();
  }

  function isApprovedForAll(address, address) public view virtual override returns (bool) {
    return false;
  }

  function transferFrom(address, address, uint256) public virtual override {
    revert TransferNotAllowed();
  }

  function safeTransferFrom(address, address, uint256, bytes memory) public virtual override {
    revert TransferNotAllowed();
  }
}
