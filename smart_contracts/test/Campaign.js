const { expect } = require("chai");
const {
  loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { ethers } = require("hardhat");



describe("Campaign", () => {
  // deploy contract
  const deployedContract = async () => {
    const contract = await ethers.deployContract("CampaignManager");
    const [owner, addr1, addr2, addr3] = await ethers.getSigners();

    return { contract, owner, addr1, addr2, addr3 };
  };

  // track creator
  it("Should track the campaign creator", async () => {
    const { contract, owner, addr1 } = await loadFixture(deployedContract);

    await contract.connect(addr1).createCampaign("test campaign", ethers.parseEther("10"), 3600);
    const campaigns = await contract.getUserCampaigns(addr1.address);
    const campaign = await ethers.getContractAt("Campaign", campaigns[0]);
    const details = await campaign.details();
    expect(details.creator).to.equal(addr1.address);
  });
});
