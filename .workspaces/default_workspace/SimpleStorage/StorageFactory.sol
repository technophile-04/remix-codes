// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SimpleStorage.sol";


contract StorageFactory {
    SimpleStorage[] public simpleStorageArr;

    function createSimpleStorage() public {
        // new keyword triggers depoly and returns depolyed address(packed with abi)
        SimpleStorage simpleStorage = new SimpleStorage();
        simpleStorageArr.push(simpleStorage);
    }

    function sfStore(uint _storageIndex, uint _simpleStorageNumber) public {
        SimpleStorage simpleStorage = simpleStorageArr[_storageIndex]; 
        simpleStorage.store(_simpleStorageNumber);
    }

    function sfGet(uint _storageIndex) public view returns(uint){
        return simpleStorageArr[_storageIndex].retrieve(); 
    }
  
}

