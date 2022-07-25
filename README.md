# Lockable
A simple approach to lock NFTs without transferring the ownership

### THIS IS A WORK IN PROGRESS

## Why

If you stake an NFT to earn some yield, you trasnfer the ownership of the NFT to a pool. That is not ideal because you may lose voting power and other benefits coming from owning a token. The solution is to lock the NFT in place so that it cannot be transferred or approved to be listed on marketplaces. Many are implementing something in the same space. This is the way I implemented it in the Everdragons2 Governance token and in the Mobland in-game assets.

## The interface


```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// Author:
// Francesco Sullo <francesco@sullo.co>

interface ILockable {
  event LockerSet(address locker);
  event LockerRemoved(address locker);
  event ForcefullyUnlocked(uint256 tokenId);
  event Locked(uint256 tokendId);
  event Unlocked(uint256 tokendId);

  // tells if a token is locked
  function isLocked(uint256 tokenID) external view returns (bool);

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

## Install and usage

To install it, launch 
``` 
npm i -d attributable
```

You may need to install the peer dependencies too, i.e., the OpenZeppelin contracts.

To use it, in your smart contract import it as

```solidity
import "@ndujalabs/lockable/contracts/ILockable.sol";
```

## Testing

You can find testing for the various functions in https://github.com/ndujaLabs/everdragons2-core/blob/main/test/Everdragons2GenesisV3.test.js#L99

As soon as I have a moment, I will add an example here and move the testing.

## Implementations

Look at an example of an upgradeable token in `/examples`.

1. **Everdragons2GenesisV3** https://github.com/ndujaLabs/everdragons2-core/blob/main/contracts/V2-V3/Everdragons2GenesisV3.sol#L99

Feel free to make a PR to add your contracts.

## Copyright

(c) 2022, Francesco Sullo <francesco@sullo.co>

## License

MIT
