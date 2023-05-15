// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FundraiserContract {
     address public owner;

    event ProjectCreated(uint projectId, uint fundingGoal, uint currentAmount, address owner);
    event ContributionMade(uint projectId, uint fundingGoal, uint currentAmount, address contributer);
    event FundingGoalUpdated(uint projectId, uint oldGoal, uint newGoal,address sender);
    event FundsWithdrawn(uint projectId, uint amount, address sender);
    event FullyFunded(uint projectId, uint fundingGoal, address sender);
    event Closed(uint projectId, address sender);

    mapping(uint => Project) public projects;

    constructor() {
        owner = msg.sender;
    }
   
    struct Project {
        uint id;
        uint fundingGoal;
        uint currentAmount;
        address payable owner;
        bool isClosed;
    }

    modifier projectMustExist(uint _projectId) {
        require(projects[_projectId].id != 0, "Project with that ID does not exist");
        _;
    }

    modifier projectNotClosed(uint _projectId) {
        require(!projects[_projectId].isClosed, "Project with that ID is closed or fully funded");
        _;
    }
        
    function createProject(uint _projectId, uint _fundingGoal) public {
        require(projects[_projectId].id == 0, "Project with that ID already exists");
        Project memory newProject = Project(_projectId, _fundingGoal, 0, payable(msg.sender), false);
        projects[_projectId] = newProject;
        emit ProjectCreated(_projectId, _fundingGoal, 0, msg.sender);
    }

    function contribute(uint _projectId) public payable projectMustExist(_projectId) projectNotClosed(_projectId) {
        require(msg.value <= projects[_projectId].fundingGoal - projects[_projectId].currentAmount, "Cannot contribute more than the funding goal");
        projects[_projectId].currentAmount += msg.value;
        emit ContributionMade(_projectId, projects[_projectId].fundingGoal, projects[_projectId].currentAmount, msg.sender);
        if (projects[_projectId].currentAmount == projects[_projectId].fundingGoal) {
            closeProject(_projectId);
            emit FullyFunded(_projectId, projects[_projectId].fundingGoal, msg.sender);
        }
    }

    function closeProject(uint _projectId) public projectMustExist(_projectId) projectNotClosed(_projectId) {
        projects[_projectId].isClosed = true;
        emit Closed(_projectId, msg.sender);
    }

    function setFundingGoal(uint _projectId, uint _fundingGoal) public projectMustExist(_projectId) projectNotClosed(_projectId) {
        require(_fundingGoal >= projects[_projectId].currentAmount, "Funding goal must be higher or equal than the current amount");
        uint oldGoal = projects[_projectId].fundingGoal;
        projects[_projectId].fundingGoal = _fundingGoal;
        emit FundingGoalUpdated(_projectId, oldGoal, _fundingGoal, msg.sender);
    }

    function getProjectTotalAmountRaised(uint _projectId) public view projectMustExist(_projectId) returns (uint) {
        return projects[_projectId].currentAmount;
    }

    function withdrawFunds(uint _projectId) public projectMustExist(_projectId) {
        require(projects[_projectId].currentAmount >= projects[_projectId].fundingGoal, "Cannot withdraw funds unless the funding goal is reached");
        require(projects[_projectId].currentAmount <= address(this).balance, "Cannot withdraw more than the raised funds");
        projects[_projectId].isClosed = true;
        uint oldAmount = projects[_projectId].currentAmount;
        projects[_projectId].owner.transfer(projects[_projectId].currentAmount);
        projects[_projectId].currentAmount = 0;
        emit FundsWithdrawn(_projectId, oldAmount, msg.sender);
    }

}
