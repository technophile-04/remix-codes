// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./PriceConverter.sol";

error NotOwner();

contract FundMe {

    using PriceConverter for uint256;  


    // Immutables and constant are not stored insied a storage slot instead they are stored in bytecode itself
    uint public  constant MIN_USD = 50 * 1e18;
    address  public immutable i_owner;

    address[] public funders;
    mapping(address => uint) public addressToAmountFunded;


    constructor() {
        i_owner = msg.sender; 
    }

    function fund() public payable {
        // msg.value.getConversionRate(); msg.value becomes first parameter of the function
        require(msg.value.getConversionRate() >= MIN_USD, "Price is lower, send more");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;
    }

    function withdraw() public onlyOwner {
        /* Reset mapping */
        for(uint i = 0; i < funders.length; i++){
            address currAddress = funders[i];
            addressToAmountFunded[currAddress] = 0;
        }

        /* Reseting the array to point to new location and intial element 0 */
        funders = new address[](0);

        // msg.sender = address
        // paybale(msg.sender) = paybale address;

        (bool callSuccess, ) = payable(address(this)).call{value : address(this).balance}("");
        require(callSuccess, "Call falied ");
    }

    modifier onlyOwner {

        // The string is stored in string array
        // require(msg.sender == i_owner, "Not owner of the contract");

        // Hence we dont store array of string
        if(msg.sender == i_owner){
            revert NotOwner(); 
        }
        _;
    }


    /* 
        A contract receiving Ether must have at least one of the functions below
        receive() external payable
        fallback() external payable
        receive() is called if msg.data is empty, otherwise fallback() is called.
    */

/*                
            send Ether
               |
         msg.data is empty?
              / \
            yes  no
            /     \
receive() exists?  fallback()
         /   \
        yes   no
        /      \
    receive()   fallback() 
    */

    receive() external payable {
        fund();
    }

    fallback() external payable{
        fund();
    }
    

}