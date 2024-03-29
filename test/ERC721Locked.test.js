const {expect} = require("chai");
const {deployContractUpgradeable, deployContract, number, getInterfaceId} = require("./helpers");

describe("ERC721Locked", function () {
  let myBadge;

  let owner, holder1, holder2, holder3, marketplace;

  before(async function () {
    [owner, holder1, holder2, holder3, marketplace] = await ethers.getSigners();
  });

  beforeEach(async function () {
    myBadge = await deployContract("MyBadge");

    await expect(myBadge.safeMint(holder1.address, 1))
        .emit(myBadge, "Transfer")
        .withArgs(ethers.constants.AddressZero, holder1.address, 1);

    expect(await myBadge.tokenOfOwnerByIndex(holder1.address, 0)).equal(1);

    await expect(myBadge.safeMint(holder2.address, 2))
        .emit(myBadge, "Transfer")
        .withArgs(ethers.constants.AddressZero, holder2.address, 2);
    await myBadge.safeMint(holder3.address, 3);

    await myBadge.safeMint(holder1.address, 4);
  });

  it("should verify the properties of the badge", async function () {

    expect(await getInterfaceId("IERC721Lockable")).equal("0x452faa60");

    expect(await myBadge.locked(1)).equal(true);

    await expect(
      myBadge.connect(holder1)["safeTransferFrom(address,address,uint256)"](holder1.address, holder2.address, 1)
    ).revertedWith("ERC721Locked: not transferable");

    await expect(myBadge.connect(holder1).transferFrom(holder1.address, holder2.address, 1)).revertedWith(
      "ERC721Locked: not transferable"
    );



  });
});
