// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Deposit {
    // we need atleast one of the payable function to get ether in contract
    receive() external payable {
        
    }
    
    fallback() external payable {
        
    }
    
    function getBalance() public view returns(uint){
            
        return address(this).balance;
        
    }
    
    function sendEther() public payable{
        // payable can be emmpty just that they are use to send ether to contract
    }
    
    function transferEther(address payable recepient, uint amount) public returns(bool) {
        
        if(amount <= getBalance()){
            recepient.transfer(amount);
            return true;
        }else{
            return false;
        }
    } 
    
}