// SPDX-License-Identifier: GPL-3.0

//  Just remember that one way is to define a function with the payable function modifier.
//  If there is a payable function a user can sent Ether to the contract by calling that function

pragma solidity >=0.7.0 <0.9.0;

contract Auction {
    
    mapping(address => uint) public bids;
    
    
    function bid() payable public {
        bids[msg.sender] = msg.value;
        // msg.value constians the amout that is sent to contract
    }
    
    // Note if the key is not found in map then it returns defalult value of that key in this case since it uint therefore it will be 0
    
}