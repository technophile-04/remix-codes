// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Property {

    /* Notes
     1)State variables cost gas
     2)State variables can only be changed by setter functions and not directly
     3)Function variables does cost gas
     4)Imp string, arrays , struc are referenced in storage by default so while using those in fucntion we have 
        to mentions memory keyword so that they are stored in memory
     5)default visibility of variable is private 
     */

    int public price;
    // string constant location="India";
    string public location="India";

    /* function functionName(arguments) visibility view/pure returns(data type){
        // function body
     }*/

     function setPrice(int _price)public {
         price = _price;
     }

    // We dont need to write getter functions coz  if the state variable is public the getter function is already created 
     function getPrice()public view returns(int){
         return price;
     }

    /* 
        view - meaning it will just return a value
        pure - meanign that it will not reference any storage variable and will not change anything in main-net
     */


     function setLocation(string memory _location)public {
         location = _location;
     }


}