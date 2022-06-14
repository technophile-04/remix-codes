// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Property {
    
    // boolean type variable 
    bool public sold;
    
    // Integer Types : 
    // 1) int8 --> -127 to -127 
    // 2) uint8 --> 0 to 255
    // similarly int8 to int256, uint8 to uint256 in steps of 8
    // int is alias to int256 and uint is an alias to uint256
    // There is no full support for float/double (fixed point numbers) in Solidity
    
    
    // Integer overFlow
    /* eg : 
    
        uint8 public x = 255;
        
        function incrmentX() public {
            
            x += 1;
            
        }
        
        In earlier versions it would have round back to 0 but after version 8 it reverts to intial state
        
        
    */
    
    uint8 public x = 255;
        
    function incrmentX() public {
        
        x += 1;
        
    }
    
}