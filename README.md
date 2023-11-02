# ERC721Lockable
A simple approach to lock NFTs without transferring the ownership

## Why

If you stake an NFT to earn some yield, you transfer the ownership of the NFT to a pool. That is not ideal because you may lose voting power and other benefits coming from owning a token. The solution is to lock the NFT in place so that it cannot be transferred or approved to be listed on marketplaces. Many are implementing something in the same space. This is the way I implemented it in the Everdragons2 Governance token and in the Mobland in-game assets.

## The interface

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// Author:
// Francesco Sullo <francesco@sullo.co>

// ERC165 interface id is 0x2e4e0d27
interface IERC721Lockable is IERC5192 {
  event LockerSet(address locker);
  event LockerRemoved(address locker);
  event ForcefullyUnlocked(uint256 tokenId);

  // tells the address of the contract which is locking a token
  function lockerOf(uint256 tokenID) external view returns (address);

  // tells if a contract is a locker
  function isLocker(address _locker) external view returns (bool);

  // set a locker, if the actor that is locking it is a contract, it
  // should be approved
  // It should emit a LockerSet event
  function setLocker(address pool) external;

  // remove a locker
  // It should emit a LockerRemoved event
  function removeLocker(address pool) external;

  // tells if an NFT has any locks on it
  // The function is called internally and externally
  function hasLocks(address owner) external view returns (bool);

  // locks an NFT
  // It should emit a Locked event
  function lock(uint256 tokenID) external;

  // unlocks an NFT
  // It should emit a Unlocked event
  function unlock(uint256 tokenID) external;

  // unlock an NFT if the locker is removed
  // This is an emergency function called by the token owner or a DAO
  // It should emit a ForcefullyUnlocked event
  function unlockIfRemovedLocker(uint256 tokenID) external;
}

```

the apparently missing events and functions are inherited from 

```solidity
// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.9;

// ERC165 interfaceId 0x6b61a747
interface IERC6982 {
  // This event MUST be emitted upon deployment of the contract, establishing
  // the default lock status for any tokens that will be minted in the future.
  // If the default lock status changes for any reason, this event
  // MUST be re-emitted to update the default status for all tokens.
  // Note that emitting a new DefaultLocked event does not affect the lock
  // status of any tokens for which a Locked event has previously been emitted.
  event DefaultLocked(bool locked);

  // This event MUST be emitted whenever the lock status of a specific token
  // changes, effectively overriding the default lock status for this token.
  event Locked(uint256 indexed tokenId, bool locked);

  // This function returns the current default lock status for tokens.
  // It reflects the value set by the latest DefaultLocked event.
  function defaultLocked() external view returns (bool);

  // This function returns the lock status of a specific token.
  // If no Locked event has been emitted for a given tokenId, it MUST return
  // the value that defaultLocked() returns, which represents the default
  // lock status.
  // This function MUST revert if the token does not exist.
  function locked(uint256 tokenId) external view returns (bool);
}
```

## Install and usage

To install it, launch 
``` 
npm i -d @ndujalabs/erc721lockable @openzeppelin/contracts @openzeppelin/contracts-upgradeable
```

To use the interface, in your smart contract import what you need as

```solidity
import "@ndujalabs/erc721lockable/IERC6982.sol";
import "@ndujalabs/erc721lockable/IERC721Lockable.sol";
import "@ndujalabs/erc721lockable/IERC721Lockable.sol";
```

and implement the required functions.

In '/contracts' there are "ERC721Lockable.sol" and "LockableUpgradeable.sol".  
Both can be extended and used as is, like

```solidity
import "@ndujalabs/erc721lockable/ERC721Lockable.sol";

contract MyToken is ERC721Lockable {
  ...
```


## Testing

You can find testing for the various functions in https://github.com/ndujaLabs/everdragons2-core/blob/main/test/Everdragons2GenesisV3.test.js#L99

As soon as I have a moment, I will add an example here and move the testing.

## Implementations

1. **Everdragons2GenesisV3** https://github.com/ndujaLabs/everdragons2-core/blob/main/contracts/V2-V3/Everdragons2GenesisV3.sol#L99

1. **MOBLAND Turf & Farm tokens** https://github.com/superpowerlabs/in-game-assets/blob/main/contracts/SuperpowerNFTBase.sol#L201

Feel free to make a PR to add your implementation.

## History

**0.11.0**
- Fix naming issue in ERC721LockedEnumerableUpgradeable, previously called ERC721LockedEnumerable by mistake

**0.10.1**
- Fix issues with numerability

**0.10.0**
- Adding enumerable versions for Locked contracts
- Optimize Locked contract removing unused functions

**0.9.0** / breaking
- Make `defaultLocked` public, instead of external

**0.8.1**
- Return `locked` returns the default locked status if not specific lock is set

**0.8.0**
- Fix signature of `setLocker`, mistakenly set as `payable`

**0.7.0**
- Removes unnecessary checks on approvals

**0.6.3**
- Fix missing virtual statements :-(

**0.6.2**
- fix issues in README about dependencies and usage
- update IERC6982 to latest version

**0.6.1**
- remove dependency from ERC721DefaultApprovable since it was not really necessary

**0.6.0**
- Adding DefaultLocked contract for Soulbound and Badges, using IERC6982

**0.5.0**
- moving from `IERC5192` to more efficient `IERC6982`
- this is a breaking change because constructor and initializing function must emit DefaultLocked and need a new parameter for it. However the contract is much more efficient.

**0.4.0** / breaking
- align `locked` to [IERC5192](https://eips.ethereum.org/EIPS/eip-5192) that specifies that it should revert if owner is address(0), i.e., if the token does not exist

**0.3.0**
- (breaking) removed the `isLocked` function in favor of `locked`, to extend the new proposal [IERC5192](https://github.com/attestate/ERC5192/blob/main/src/IERC5192.sol). As a consequence the interfaceId is changed from `0xd8e4c296` to `0x2e4e0d27`

**0.2.0**
- (breaking change) The upgradeable version is not extending UUPSUpgradeable anymore, leaving the developer to decide with proxy to use. This implies that whoever is using ERC721Lockable without importing UUPSUpgradeable, now has to import it explicitly.

**0.1.2**
- Use `pragma solidity ^0.8.0;` instead of specific version

**0.1.1**
- Adding repo to package.json

**0.1.0**
- interface renamed from **ILockable** to **IERC721Lockable** for clarity

**0.0.4**
- remove `initialize` (which was used in the example) and use `__Lockable_init` to allow extensions
- add `__gap` at the end of `LockableUpgradeable`
- add mock to allow testing

**0.0.3**
- `ERC721Lockable.getApproved` does not return address(0) if the token is locked but the caller is the locker. This allows the locker to stake the token transferring it.
- Makes function in `ERC721Lockable` virtual to be overridden if necessary

## Copyright

(c) 2022, Francesco Sullo <francesco@sullo.co>

## License

MIT
