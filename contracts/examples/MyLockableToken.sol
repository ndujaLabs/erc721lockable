// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

// Authors: Francesco Sullo <francesco@sullo.co>

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "../ILockable.sol";

contract MyLockableToken is ILockable, Initializable, OwnableUpgradeable, ERC721Upgradeable, ERC721EnumerableUpgradeable, UUPSUpgradeable {
  using AddressUpgradeable for address;

  mapping(address => bool) public pools;
  mapping(uint256 => address) public staked;

  modifier onlyLocker() {
    require(pools[_msgSender()], "Forbidden");
    _;
  }

  /// @custom:oz-upgrades-unsafe-allow constructor
  constructor() initializer {}

  function initialize() public initializer {
    __ERC721_init("My Lockable Token", "MLT");
    __Ownable_init();
  }

  function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

  function _beforeTokenTransfer(
    address from,
    address to,
    uint256 tokenId
  ) internal override(ERC721Upgradeable, ERC721EnumerableUpgradeable) {
    require(!isLocked(tokenId), "Token is locked");
    super._beforeTokenTransfer(from, to, tokenId);
  }

  function supportsInterface(bytes4 interfaceId)
    public
    view
    override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
    returns (bool)
  {
    return interfaceId == type(ILockable).interfaceId || super.supportsInterface(interfaceId);
  }


  function isLocked(uint256 tokenId) public view override returns (bool) {
    return staked[tokenId] != address(0);
  }

  function lockerOf(uint256 tokenId) external view override returns (address) {
    return staked[tokenId];
  }

  function isLocker(address locker) public view override returns (bool) {
    return pools[locker];
  }

  function setLocker(address locker) external override onlyOwner {
    require(locker.isContract(), "locker not a contract");
    pools[locker] = true;
    emit LockerSet(locker);
  }

  function removeLocker(address locker) external override onlyOwner {
    require(pools[locker], "not an active locker");
    delete pools[locker];
    emit LockerRemoved(locker);
  }

  function hasLocks(address owner) public view override returns (bool) {
    uint256 balance = balanceOf(owner);
    for (uint256 i = 0; i < balance; i++) {
      uint256 id = tokenOfOwnerByIndex(owner, i);
      if (isLocked(id)) {
        return true;
      }
    }
    return false;
  }

  function lock(uint256 tokenId) external override onlyLocker {
    // locker must be approved to mark the token as locked
    require(isLocker(_msgSender()), "Not an authorized locker");
    require(getApproved(tokenId) == _msgSender() || isApprovedForAll(ownerOf(tokenId), _msgSender()), "Locker not approved");
    staked[tokenId] = _msgSender();
    emit Locked(tokenId);
  }

  function unlock(uint256 tokenId) external override onlyLocker {
    // will revert if token does not exist
    require(staked[tokenId] == _msgSender(), "wrong locker");
    delete staked[tokenId];
    emit Unlocked(tokenId);
  }

  // emergency function in case a compromised locker is removed
  function unlockIfRemovedLocker(uint256 tokenId) external override onlyOwner {
    require(isLocked(tokenId), "not a locked tokenId");
    require(!pools[staked[tokenId]], "locker is still active");
    delete staked[tokenId];
    emit ForcefullyUnlocked(tokenId);
  }

  // manage approval

  function approve(address to, uint256 tokenId) public override {
    require(!isLocked(tokenId), "locked asset");
    super.approve(to, tokenId);
  }

  function getApproved(uint256 tokenId) public view override returns (address) {
    if (isLocked(tokenId)) {
      return address(0);
    }
    return super.getApproved(tokenId);
  }

  function setApprovalForAll(address operator, bool approved) public override {
    require(!approved || !hasLocks(_msgSender()), "at least one asset is locked");
    super.setApprovalForAll(operator, approved);
  }

  function isApprovedForAll(address owner, address operator) public view override returns (bool) {
    if (hasLocks(owner)) {
      return false;
    }
    return super.isApprovedForAll(owner, operator);
  }

  function getInterfaceId() external view returns (bytes4){
    return type(ILockable).interfaceId;
  }

}
