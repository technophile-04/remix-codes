// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 < 0.9.0;

contract ConstructPractice {
    
    string buyerName;
    
    constructor(string memory name){
        buyerName = name;
    }
    
    
    function getName() public view returns(string memory){
        return buyerName;
    }
}