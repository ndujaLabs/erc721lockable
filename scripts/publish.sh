#!/usr/bin/env bash

cp README.md contracts/README.md
cd contracts
pnpm publish
rm README.md
cd ..
