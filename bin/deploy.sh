#!/usr/bin/env bash

# example:
#
#   bin/deploy.sh nft goerli "Mobland Turf" MLT "https://turf.mob.land/metadata/"
#

NAME=$3 SYMBOL=$4 TOKEN_URI=$5 npx hardhat run scripts/deploy-$1.js --network $2
