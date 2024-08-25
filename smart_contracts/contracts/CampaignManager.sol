// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Campaign.sol";

contract CampaignManager {
    Campaign[] public campaigns;

    mapping(address => Campaign[]) public userCampaigns;

    event CampaignCreated(
        address campaignAddress,
        address creator,
        uint goal,
        uint duration
    );

    function createCampaign(
        string memory _title,
        uint _goal,
        uint _duration
    ) public {
        Campaign newCampaign = new Campaign(
            msg.sender,
            _title,
            _goal,
            _duration
        );
        newCampaign.transferOwnership(msg.sender);

        campaigns.push(newCampaign);
        userCampaigns[msg.sender].push(newCampaign);

        emit CampaignCreated(
            address(newCampaign),
            msg.sender,
            _goal,
            _duration
        );
    }

    function getCampaigns() public view returns (Campaign[] memory) {
        return campaigns;
    }

    function getUserCampaigns(
        address user
    ) public view returns (Campaign[] memory) {
        return userCampaigns[user];
    }
}
