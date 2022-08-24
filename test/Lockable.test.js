const {expect} = require("chai");
const { deployContractUpgradeable} = require("./helpers");

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
    myToken = await deployContractUpgradeable("LockableUpgradeableMock", ["My token", "NFT"]);
  });

  it("should verify the flow", async function () {

    expect(await myToken.supportsInterface("0xd8e4c296")).equal(true)


  });

});
