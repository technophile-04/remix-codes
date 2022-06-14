// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract stringAndBytes {
    
    bytes public b = 'shiv';
    string public s = "blah";
    
    // Variables of type bytes and
    // string are special dynamic arrays.
    
    // String is equal to bytes but does not allow length or index access. A string is UTF-8 encoded in solidity
    
    
    function addElement() public {
        b.push('x');
    }
    
    // in byte's arrays it's possible to access the elements of the array using indexing.
    function getElement() public view returns(bytes1){
        return b[1];
    }
    
    
    // Note that the bytes and strings are reference types, not of value types, and also pay attention that fixed size arrays use less gas than dynamic arrays.
    
       
}