// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 < 0.9.0;


contract Lottery {
    
    address payable[] public players;
    
    address public immutable manager;
    
    constructor () {
        manager = msg.sender;
    }
    
    receive() external payable {
         // 100000000000000000 wei = 0.1 eth we can also write 0.1 ether instead of mentionion whole number
        // require(msg.value == 100000000000000000)
        // msg.value represent the amount of ether in wei that is send in trasaction to the contract
        
        require(msg.value == 0.1 ether);
        
        players.push(payable(msg.sender));
    }
    
    
    function getBalance() public view returns(uint){
        require(msg.sender == manager);
        return address(this).balance;
    }
    
    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }
    
    function pickWinner() public{
        
        require(msg.sender == manager);
        require(players.length >= 2);
        
        uint randomNumber = random();
        address payable winner;
        
        uint winnerIndex = randomNumber % players.length;
        
        winner = players[winnerIndex];
        
        winner.transfer(getBalance());
        
        players = new  address payable[](0);
    
    }
    
}










