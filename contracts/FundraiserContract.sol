// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "hardhat/console.sol";

contract FundraiserContract {
    address owner;

    event ProjectCreated(uint projectId, uint fundingGoal, uint currentAmount, address owner);
    event ContributionMade(uint projectId, uint fundingGoal, uint currentAmount, address contributer);
    event FundingGoalUpdated(uint projectId, uint oldGoal, uint newGoal, uint currentAmount, address sender);

    mapping(uint => Project) public projects;

    constructor() {
        owner = msg.sender;
    }
   
    struct Project {
        uint id;
        uint fundingGoal;
        uint currentAmount;
        address payable owner;
    }

    function createProject(uint _projectId, uint _fundingGoal) public {
        console.log("Creating a new project");
    }

    function contribute(uint _projectId) public payable {
        console.log("Contributing to a project");
    }

    function setFundingGoal(uint _projectId, uint _fundingGoal) public {
        console.log("Setting the funding goal for a project");
    }

    function getProjectTotalAmountRaised(uint _projectId) public view returns (uint) {
        console.log("Getting the total amount raised for a project");
        return 0;
    }
 

}
