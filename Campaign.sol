pragma solidity ^0.4.19;
contract Campaign {
    address public manager;
    uint public minimumContribution;
    mapping(address => bool) public approvers;
    uint public approversCount;

    struct Request {
        string description;
        uint value;
        address recipient;
        bool complete;
        uint approvalCount;
        mapping(address=>bool) approvals;
    }

    Request[] public requests;

    modifier restricted(){
        require(msg.sender==manager);
        _;
    }

    function Campaign(uint minimum) public {
        manager=msg.sender;
        minimumContribution=minimum;
    }

    //payable makes this function able to receive ether
    function contribute() public payable {
        require(msg.value > minimumContribution);
        approvers[msg.sender]=true;
        approversCount++;
    }

    function createRequest(string description, uint value, address recipient) public restricted {
        Request memory newRequest=Request({
           description: description,
           value:value,
           recipient: recipient,
           complete: false,
           approvalCount:0
        });

        requests.push(newRequest);
    }

    function approveRequest(uint index) public {
        //Request storage when this storage has value.
        Request storage request= requests[index];
        require(approvers[msg.sender]);
        //if this person already vote, then do below.
        require(!request.approvals[msg.sender]);
        request.approvals[msg.sender]=true;
        request.approvalCount++;
    }


    function finalizeRequest(uint index) public restricted {
        Request storage request= requests[index];
        require(!request.complete);
        require(request.approvalCount>(approversCount/2));
        request.recipient.transfer(request.value * 1000000000000000000);
        request.complete=true;
    }

}
