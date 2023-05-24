const {expect} = require("chai");
const {deployContractUpgradeable, deployContract, number} = require("../../../Cruna/ds-protocol/test/helpers");

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
    expect(await myBadge.getInterfacesIds()).deep.equal(["0x2281ffc3", "0x6b61a747"]);

    expect(await myBadge.locked(1)).equal(true);
    expect(await myBadge.approvable(1)).equal(false);

    await expect(myBadge.connect(holder1).approve(marketplace.address, 1)).revertedWith("ApprovalNotAllowed()");

    await expect(myBadge.connect(holder1).setApprovalForAll(marketplace.address, true)).revertedWith("ApprovalNotAllowed()");

    await expect(
      myBadge.connect(holder1)["safeTransferFrom(address,address,uint256)"](holder1.address, holder2.address, 1)
    ).revertedWith("TransferNotAllowed()");

    await expect(myBadge.connect(holder1).transferFrom(holder1.address, holder2.address, 1)).revertedWith(
      "TransferNotAllowed()"
    );
  });
});
