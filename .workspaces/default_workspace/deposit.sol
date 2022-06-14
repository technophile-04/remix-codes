//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract Deposit{
    
    address immutable admin;
    
    constructor(){
        
        admin = msg.sender;
        
    }
    
    receive() external payable {
        
    }
    
    function sendEther() public payable {
        
    }
    
    
    function getBalance() public view returns(uint){
        return address(this).balance;
    }
    
    function transferAllEthers(address payable recepient) public returns(bool){
        uint balance = getBalance();
        
        require(admin == msg.sender, "You are not allowed to do that you are not the owner!");
        
        if(balance != 0){
            recepient.transfer(balance);
            return true;
        }
        
        return false;
    }
    
    
}