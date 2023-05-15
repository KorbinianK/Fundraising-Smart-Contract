// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FundraiserContract {
     address public owner;

    event ProjectCreated(uint projectId, uint fundingGoal, uint currentAmount, address owner);
    event ContributionMade(uint projectId, uint fundingGoal, uint currentAmount, address contributer);
    event FundingGoalUpdated(uint projectId, uint oldGoal, uint newGoal,address sender);

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

    modifier projectMustExist(uint _projectId) {
        require(projects[_projectId].id != 0, "Project with that ID does not exist");
        _;
    }

    function createProject(uint _projectId, uint _fundingGoal) public {
        require(projects[_projectId].id == 0, "Project with that ID already exists");
        Project memory newProject = Project(_projectId, _fundingGoal, 0, payable(msg.sender));
        projects[_projectId] = newProject;
        emit ProjectCreated(_projectId, _fundingGoal, 0, msg.sender);
    }

    function contribute(uint _projectId) public payable projectMustExist(_projectId) {
        require(msg.value <= projects[_projectId].fundingGoal - projects[_projectId].currentAmount, "Cannot contribute more than the funding goal");
        projects[_projectId].currentAmount += msg.value;
        emit ContributionMade(_projectId, projects[_projectId].fundingGoal, projects[_projectId].currentAmount, msg.sender);
    }

    function setFundingGoal(uint _projectId, uint _fundingGoal) public projectMustExist(_projectId) {
        require(_fundingGoal >= projects[_projectId].currentAmount, "Funding goal must be higher or equal than the current amount");
        uint oldGoal = projects[_projectId].fundingGoal;
        projects[_projectId].fundingGoal = _fundingGoal;
        emit FundingGoalUpdated(_projectId, oldGoal, _fundingGoal, msg.sender);
    }

    function getProjectTotalAmountRaised(uint _projectId) public view projectMustExist(_projectId) returns (uint) {
        return projects[_projectId].currentAmount;
    }

}
