// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;
import  'hardhat/console.sol';


contract WavePortal {
    uint totalWaves;

    event NewWave(address indexed _from , string  message, uint timestamp);

    struct Wave {
        address waver;
        string message;
        uint timestamp;
    }
    Wave[] waves;

    constructor() payable{
        console.log("I AM SMART CONTRACT. POG.");
    }

    // wave 
    function wave(string memory _message) public{
        totalWaves += 1;
        console.log("%s waved with message %s", msg.sender, _message);
        waves.push(Wave(msg.sender, _message, block.timestamp));
        emit NewWave(msg.sender, _message, block.timestamp);

        uint prizeAmount = 0.0001 ether;
        uint contractBalance = address(this).balance;
        require(prizeAmount <= contractBalance, 'Sorry I ran out of eth!');

        address payable sender = payable(msg.sender);
        bool success = sender.send(prizeAmount);
        require(success, "Failed to withdraw money from contract.");
    }

    // Total waves
    function getTotalWaves() public view returns(uint) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }

    // get all waves
    function getAllWaves() public view returns(Wave[] memory) {
        return waves;
    }


}