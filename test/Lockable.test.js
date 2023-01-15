const {expect} = require("chai");
const { deployContractUpgradeable} = require("./helpers");

describe("ERC721Lockable", function () {
  let myPool;
  let myToken;

  let owner, holder;
  let tokenId = 1;

  before(async function () {
    [owner, holder] = await ethers.getSigners();
  });

  beforeEach(async function () {
    // myPool = await deployContract("MyPlayer");
    myToken = await deployContractUpgradeable("ERC721LockableUpgradeableMock", ["My token", "NFT"]);
  });

  it("should verify the flow", async function () {

    console.log(await myToken.getInterfaceId());

    expect(await myToken.supportsInterface("0x2e4e0d27")).equal(true)

  });

});
