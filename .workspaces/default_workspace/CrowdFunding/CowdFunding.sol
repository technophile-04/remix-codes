// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.6.0 < 0.9.0;

contract CrowdFunding{

    mapping(address => uint) public contributors;
    address public admin;
    uint public noOfContributors;
    uint public minContribution;
    uint public deadline; 
    uint public goal;
    uint public totalRaisedAmount;
    struct Request {
        string description;
        address payable recepient;
        uint value;
        bool completed;
        uint noOfVoters;
        mapping(address => bool) voters;
    }

    mapping(uint => Request) public requests;
    // We haven't used arrays here because in latest versions arrays are not allowed to store mapping type variables in them.Our request has a mapping variable
    uint noOfRequests;

    constructor(uint _goal, uint _deadline){

        goal = _goal;
        deadline = block.timestamp +_deadline;
        minContribution = 100 wei;
        admin = msg.sender;

    }     

    event ContributeEvent(address _sender,uint _value);
    event CreateRequestEvent(string _description, address _receipent, uint _value);
    event MakePaymentEvent(address _receipent, uint _value);

    function contribute() public payable {
        require(block.timestamp < deadline, "The deadline has been has passed");
        require(msg.value >= minContribution, "Value muste be greate than 100 wei");

        if(contributors[msg.sender] == 0){
            noOfContributors++;
        }

        contributors[msg.sender] += msg.value;

        totalRaisedAmount += msg.value;

        emit ContributeEvent(msg.sender, msg.value);

    }

    receive() payable external {
        contribute();
    }

    function getTotalAmountRaised() public view returns(uint){
        return address(this).balance;
    }

    function getRefund() public {
        require(contributors[msg.sender] > 0, "You have not contributed any amount");
        require(block.timestamp > deadline && totalRaisedAmount < goal, "Either dedline hasn't reached or Goal is ovecome");

        address payable recepient = payable(msg.sender);

        recepient.transfer(contributors[msg.sender]);

        contributors[msg.sender] = 0;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "You should be admin to do this!");
        _;
    }

    function createRequest(string memory _description, address payable _receipent, uint _value) public onlyAdmin{
        Request storage newRequest = requests[noOfRequests];
        noOfRequests++;

        newRequest.description = _description;
        newRequest.recepient = _receipent;
        newRequest.value = _value;
        newRequest.completed = false;
        newRequest.noOfVoters = 0;

        emit CreateRequestEvent(_description, _receipent, _value);

    }

    function voteRequest(uint requestNo) public {
        require(contributors[msg.sender] > 0, "You must be contributor to vote" );

        Request storage currentRequest = requests[requestNo];

        require(currentRequest.voters[msg.sender] == false, "You have already voted");

        currentRequest.voters[msg.sender] = true;
        currentRequest.noOfVoters++;

    }

    function makePayment(uint requestNo) public onlyAdmin {

        require(totalRaisedAmount >= goal, "The amount raised is less than goal");
        Request storage currentRequest = requests[requestNo];
        require(currentRequest.completed == false, "The request is already completed");
        require(currentRequest.noOfVoters > noOfContributors / 2,"The votes are less");

        currentRequest.recepient.transfer(currentRequest.value);

        currentRequest.completed = true;

        emit MakePaymentEvent(currentRequest.recepient, currentRequest.value);

    } 


}