#!/usr/bin/env node

const pkg = require("../package.json");
const pkgc = require("../contracts/package.json");

if (pkg.version !== pkgc.version) {
  console.error("package.json and contracts/package.json are out of sync");
  process.exit(1);
}
