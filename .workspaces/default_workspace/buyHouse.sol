// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 < 0.9.0;

contract BuyHouse {

    enum  Status {Vaccant, Occupied}
    Status houseStatus;

    uint public roomCost;

    address payable public owner;
    
    constructor(uint _roomCost) {
        owner = payable (msg.sender); 
        houseStatus = Status.Vaccant;
        roomCost = _roomCost;
    }

    function book() public payable{
        require(msg.value == roomCost, "The room cost is not matched");
        require(houseStatus == Status.Vaccant,"The house is alreday booked");
        owner.transfer(msg.value);
        houseStatus = Status.Occupied;
        owner = payable(msg.sender);
    }

}