const {expect, assert} = require("chai");
const {deployContract, deployContractUpgradeable} = require("./helpers");

describe("Lockable", function () {
  let myPool;
  let myToken;

  let owner, holder;
  let tokenId = 1;

  before(async function () {
    [owner, holder] = await ethers.getSigners();
  });

  beforeEach(async function () {
    // myPool = await deployContract("MyPlayer");
    myToken = await deployContractUpgradeable("MyLockableToken");
  });

  it("should verify the flow", async function () {

    // TODO

    expect(await myToken.getInterfaceId()).equal("0xd8e4c296")


  });

});
