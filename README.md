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

the apparently missing events and functions are inherited from IERC5192
``` solidity
interface IERC5192 {
  event Locked(uint256 tokenId);

  event Unlocked(uint256 tokenId);

  function locked(uint256 tokenId) external view returns (bool);
}
```

## Install and usage

To install it, launch 
``` 
npm i -d attributable
```

You may need to install the peer dependencies too, i.e., the OpenZeppelin contracts.

To use the interface, in your smart contract import it as

```solidity
import "@ndujalabs/lockable/contracts/IERC721Lockable.sol";
```

and implement the required functions.

In '/contracts' there are "ERC721Lockable.sol" and "LockableUpgradeable.sol".  
Both can be extended and used as is, like

```solidity
import "@ndujalabs/lockable/contracts/ERC721Lockable.sol";

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
