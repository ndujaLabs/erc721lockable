#!/usr/bin/env bash
# must be run from the root

#rm -rf artifacts
#rm -rf cache
npx hardhat compile

CONTRACT=$1 GAS_LIMIT=$3 npx hardhat run scripts/upgrade.js --network $2
