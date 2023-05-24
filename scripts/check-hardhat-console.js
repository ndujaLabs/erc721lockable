#!/usr/bin/env node

const {execSync} = require("child_process");
const path = require("path");

try {
  const result = execSync(`grep -r 'import "hardhat' ${path.resolve(__dirname, "../contracts")}`).toString();
  if (/:import/.test(result)) {
    console.error("At least a console.log has been left in the contracts");
    process.exit(1);
  }
} catch (e) {
  // nothing found
}
