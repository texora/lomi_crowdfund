const { ethers } = require("hardhat");

const contractAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3";

const getContractInstance = async () => {
  const campaign = await ethers.getContractFactory("CampaignManager");
  return campaign.attach(contractAddress);
};

const createCampaign = async (campaignManager) => {
  const goal = ethers.parseEther("10");
  const duration = 3600;

  const tx = await campaignManager.createCampaign(goal, duration);
  await tx.wait();

  console.log("tx", tx);
  console.log("Campaign created successfully!");
};

const main = async () => {
  const [owner, address1, address2] = await ethers.getSigners();
  const campaignManager = await getContractInstance();
  await createCampaign(campaignManager);
};

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
