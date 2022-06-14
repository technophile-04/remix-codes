// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

struct Instructor {
        
    uint age;
    string name;
    address addr;
    
}

contract Academy {
    
    Instructor public academyInstructor;
    
    constructor(uint _age, string memory _name){
            
            academyInstructor.age = _age;
            academyInstructor.name = _name;
            academyInstructor.addr = msg.sender;
        
    }
    
    function setInstructor(uint _age, string memory _name, address _addr) public {
        
        Instructor memory newInstructor = Instructor({
            age : _age,
            name : _name,
            addr : _addr
        });
        
        academyInstructor = newInstructor;
    }
    
}

contract School {
    Instructor public schoolInstructor;
}