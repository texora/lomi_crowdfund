const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("CampaignManagerModule", (m) => {
  const CampaignManager = m.contract("CampaignManager");

  return { CampaignManager };
});
