// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Authors: Francesco Sullo <francesco@sullo.co>

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "./IERC721Lockable.sol";

contract ERC721LockableUpgradeable is
  IERC721Lockable,
  Initializable,
  OwnableUpgradeable,
  ERC721Upgradeable,
  ERC721EnumerableUpgradeable
{
  using AddressUpgradeable for address;

  mapping(address => bool) private _locker;
  mapping(uint256 => address) private _lockedBy;

  modifier onlyLocker() {
    require(_locker[_msgSender()], "Forbidden");
    _;
  }

  /**
   * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
   */
  // solhint-disable-next-line
  function __ERC721Lockable_init(string memory name_, string memory symbol_) internal onlyInitializing {
    __ERC721Lockable_init_unchained(name_, symbol_);
  }

  // solhint-disable-next-line
  function __ERC721Lockable_init_unchained(string memory name_, string memory symbol_) internal onlyInitializing {
    __ERC721_init(name_, symbol_);
    __Ownable_init();
  }

  function _beforeTokenTransfer(
    address from,
    address to,
    uint256 tokenId
  ) internal override(ERC721Upgradeable, ERC721EnumerableUpgradeable) {
    require(!locked(tokenId), "Token is locked");
    super._beforeTokenTransfer(from, to, tokenId);
  }

  function supportsInterface(bytes4 interfaceId)
    public
    view
    override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
    returns (bool)
  {
    return
      interfaceId == type(IERC5192).interfaceId ||
      interfaceId == type(IERC721Lockable).interfaceId ||
      super.supportsInterface(interfaceId);
  }

  function locked(uint256 tokenId) public view virtual override returns (bool) {
    return _lockedBy[tokenId] != address(0);
  }

  function lockerOf(uint256 tokenId) public view virtual override returns (address) {
    return _lockedBy[tokenId];
  }

  function isLocker(address locker) public view virtual override returns (bool) {
    return _locker[locker];
  }

  function setLocker(address locker) external virtual override onlyOwner {
    require(locker.isContract(), "Locker not a contract");
    _locker[locker] = true;
    emit LockerSet(locker);
  }

  function removeLocker(address locker) external virtual override onlyOwner {
    require(_locker[locker], "Not an active locker");
    delete _locker[locker];
    emit LockerRemoved(locker);
  }

  function hasLocks(address owner) public view virtual override returns (bool) {
    uint256 balance = balanceOf(owner);
    for (uint256 i = 0; i < balance; i++) {
      uint256 id = tokenOfOwnerByIndex(owner, i);
      if (locked(id)) {
        return true;
      }
    }
    return false;
  }

  function lock(uint256 tokenId) external virtual override onlyLocker {
    // locker must be approved to mark the token as locked
    require(isLocker(_msgSender()), "Not an authorized locker");
    require(getApproved(tokenId) == _msgSender() || isApprovedForAll(ownerOf(tokenId), _msgSender()), "Locker not approved");
    _lockedBy[tokenId] = _msgSender();
    emit Locked(tokenId);
  }

  function unlock(uint256 tokenId) external virtual override onlyLocker {
    // will revert if token does not exist
    require(_lockedBy[tokenId] == _msgSender(), "Wrong locker");
    delete _lockedBy[tokenId];
    emit Unlocked(tokenId);
  }

  // emergency function in case a compromised locker is removed
  function unlockIfRemovedLocker(uint256 tokenId) external virtual override {
    require(locked(tokenId), "Not a locked tokenId");
    require(!_locker[_lockedBy[tokenId]], "Locker is still active");
    require(ownerOf(tokenId) == _msgSender(), "Not the asset owner");
    delete _lockedBy[tokenId];
    emit ForcefullyUnlocked(tokenId);
  }

  // manage approval

  function approve(address to, uint256 tokenId) public virtual override {
    require(!locked(tokenId), "Locked asset");
    super.approve(to, tokenId);
  }

  function getApproved(uint256 tokenId) public view virtual override returns (address) {
    if (locked(tokenId) && lockerOf(tokenId) != _msgSender()) {
      return address(0);
    }
    return super.getApproved(tokenId);
  }

  function setApprovalForAll(address operator, bool approved) public virtual override {
    require(!approved || !hasLocks(_msgSender()), "At least one asset is locked");
    super.setApprovalForAll(operator, approved);
  }

  function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
    if (hasLocks(owner)) {
      return false;
    }
    return super.isApprovedForAll(owner, operator);
  }

  uint256[50] private __gap;
}
