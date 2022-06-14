// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";


library PriceConverter {

    // They can't have state variables and also all func will be internal
    function getPrice()  internal view  returns (uint)  {

       AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
       (
            /*uint80 roundID*/,
            int price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();
        //because returned value has 8 decimal place and our msg.value is of 18
       return uint256(price * 1e10);

    }

    function getConversionRate(uint _ethAmount) internal view returns(uint) {
        uint currEthPrice = getPrice();
        uint ethAmountToUSD = (currEthPrice * _ethAmount) / 1e18;
        return ethAmountToUSD;
    }


}