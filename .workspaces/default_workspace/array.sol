// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 < 0.9.0;

contract Array {
    
    /*uint[5] public arr = [4,8,3,1];
    
    function setArray(uint index, uint value) public {
        
        arr[index] = value;
        
    }
    
    function getLength() public view returns (uint){
        return arr.length;
    } */
    
    // Dynamic arrays
    uint [] public arr;
    
    function pushElement(uint value) public {
        arr.push(value);
    } 
    
    
    function popElement() public {
        arr.pop();
    }
    
    function getLength() public view returns (uint){
        
        return arr.length;
        
    }
    
    
    
    
}