const {expect, assert} = require("chai");
const {deployContract, deployContractUpgradeable} = require("./helpers");

describe("Attributable", function () {
  let myPlayer;
  let myToken;

  let owner, holder;
  let tokenId = 1;

  const tokenData = {
    version: 1,
    level : 2,
    stamina: 123432,
    winner: "0x426eb88af949cd5bd8a272031badc2f80330e766"
  }

  before(async function () {
    [owner, holder] = await ethers.getSigners();
  });

  beforeEach(async function () {
    myPlayer = await deployContract("MyPlayer");
    myToken = await deployContractUpgradeable("MyTokenUpgradeable");
  });

  it("should verify the flow", async function () {

    await myToken.connect(owner).mint(holder.address);
    expect(await myToken.ownerOf(tokenId)).to.equal(holder.address);
    let attributes = await myToken.attributesOf(tokenId, myPlayer.address, 0);
    expect(attributes).to.equal(0);

    await expect(myPlayer.updateAttributesOf(
      myToken.address,
      tokenId,
      tokenData
    )).revertedWith("Not the operator")

    await myPlayer.setOperator(owner.address);

    await expect(myPlayer.updateAttributesOf(
        myToken.address,
        tokenId,
        tokenData
    )).revertedWith("Player not authorized")

    await myToken.connect(holder).authorizePlayer(tokenId, myPlayer.address);

    await myPlayer.updateAttributesOf(
        myToken.address,
        tokenId,
        tokenData
    )

    attributes = await myToken.attributesOf(tokenId, myPlayer.address, 0);
    expect(attributes).to.equal("106752917089902064595775439782685550631690247383499200986087937");

    const stringAttributes = await myPlayer.attributesOf(myToken.address, tokenId)
    expect(stringAttributes).equal("uint8 version:1;uint8 level:10242;uint32 stamina:123432;address winner:0x426eb88af949cd5bd8a272031badc2f80330e766")
  });

});
