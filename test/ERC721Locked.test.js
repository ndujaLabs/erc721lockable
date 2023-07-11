const {expect} = require("chai");
const {deployContractUpgradeable, deployContract, number} = require("./helpers");

describe("ERC721Locked", function () {
  let myBadge;

  let owner, holder1, holder2, holder3, marketplace;

  before(async function () {
    [owner, holder1, holder2, holder3, marketplace] = await ethers.getSigners();
  });

  beforeEach(async function () {
    myBadge = await deployContract("MyBadge");

    await myBadge.safeMint(holder1.address, 1);
    await myBadge.safeMint(holder2.address, 2);
    await myBadge.safeMint(holder3.address, 3);

    await myBadge.safeMint(holder1.address, 4);
  });

  it("should verify the properties of the badge", async function () {

    expect(await myBadge.locked(1)).equal(true);

    await expect(
      myBadge.connect(holder1)["safeTransferFrom(address,address,uint256)"](holder1.address, holder2.address, 1)
    ).revertedWith("ERC721Locked: not transferable");

    await expect(myBadge.connect(holder1).transferFrom(holder1.address, holder2.address, 1)).revertedWith(
      "ERC721Locked: not transferable"
    );
  });
});
