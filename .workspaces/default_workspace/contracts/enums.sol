// SPDX-License-Identifier: GPL-3.0

// Enums restrict a variable to have one of only a few predefined values. The values in this enumerated list are called enums.

// With the use of enums it is possible to reduce the number of bugs in your code.

//For example, if we consider an application for a fresh juice shop, it would be possible to restrict the glass size to small, medium, and large. This would make sure that it would not allow anyone to order any size other than small, medium, or large.

pragma solidity >=0.7.0 <0.9.0;

contract test {
   enum FreshJuiceSize{ SMALL, MEDIUM, LARGE }
   FreshJuiceSize choice;
   FreshJuiceSize constant defaultChoice = FreshJuiceSize.MEDIUM;

   function setLarge() public {
      choice = FreshJuiceSize.LARGE;
   }
   function getChoice() public view returns (FreshJuiceSize) {
      return choice;
   }
   function getDefaultChoice() public pure returns (uint) {
      return uint(defaultChoice);
   }
}

// If we setLarge and getChoice the output will index of large i.e 2