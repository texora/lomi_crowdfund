// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Campaign is Ownable {
    struct Contributor {
        address _contributor;
        uint _amount;
    }

    struct CampaignDetails {
        address creator;
        string title;
        uint goal;
        uint deadline;
        uint raisedAmount;
        bool successful;
        bool fundsWithdrawn;
    }

    CampaignDetails public details;
    Contributor[] public contributors;
    mapping(address => uint) public contributions;

    event ContributionReceived(address contributor, uint amount);
    event FundsWithdrawn(address owner, uint amount);
    event RefundsIssued(address contributor, uint amount);

    constructor(
        address _creator,
        string memory _title,
        uint _goal,
        uint _duration
    ) Ownable(msg.sender) {
        details.creator = _creator;
        details.title = _title;
        details.goal = _goal;
        details.deadline = block.timestamp + _duration;
    }

    function contribute() public payable {
        require(block.timestamp < details.deadline, "Campaign has ended");
        require(msg.value > 0, "Contribution must be greater than zero");

        if (contributions[msg.sender] == 0) {
            contributors.push(
                Contributor({_contributor: msg.sender, _amount: msg.value})
            );
        } else {
            for (uint256 i = 0; i < contributors.length; i++) {
                if (contributors[i]._contributor == msg.sender) {
                    contributors[i]._amount += msg.value;
                    break;
                }
            }
        }

        contributions[msg.sender] += msg.value;
        details.raisedAmount += msg.value;

        emit ContributionReceived(msg.sender, msg.value);
    }

    function getContributors() public view returns (Contributor[] memory) {
        return contributors;
    }

    function issueRefunds() public {
        require(
            block.timestamp > details.deadline,
            "Campaign is still ongoing"
        );
        require(details.raisedAmount < details.goal, "Funding goal was met");
        require(contributions[msg.sender] > 0, "No contributions to refund");

        uint refundAmount = contributions[msg.sender];
        contributions[msg.sender] = 0;

        for (uint i = 0; i < contributors.length; i++) {
            if (contributors[i]._contributor == msg.sender) {
                contributors[i]._amount = 0;

                break;
            }
        }

        payable(msg.sender).transfer(refundAmount);
        emit RefundsIssued(msg.sender, refundAmount);
    }
}
