// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;
 
import {Test, console} from "forge-std/Test.sol";
import {console} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";
 
contract FundMeTest is Test {
   FundMe fundMe;
 
    address USER = makeAddr("user");
    uint256 SEND_AMOUNT = 0.1 ether;
    uint256 STARTING_BALANCE = 10 ether;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }
 
   // function setUp() external {
   //    DeployFundMe deployFundMe = new DeployFundMe();
   //    fundMe = deployFundMe.run();
   // }

   function testMinimumUsdIsFive() public view {
      uint256 minUsd = fundMe.MINIMUM_USD();
      assertEqUint(minUsd, 5*10**18);
   }

   function testFundFailsWithoutEnoughEth() public {
      vm.expectRevert();
      fundMe.fund();
   }

   function testFundDataStructureUpdated() public {
      vm.prank(USER); //The next tx will be sent bu USER
      //We pass 1 ETH for funding
      fundMe.fund{value: SEND_AMOUNT}();
      uint256 amountFunded = fundMe.getAmountFundedByAddress(USER);
      console.log(amountFunded);
      //We test that amount funded equals to 1 ETH
      assertEq(amountFunded, SEND_AMOUNT);
   }

   modifier funded() {
      vm.prank(USER);
      fundMe.fund{value: SEND_AMOUNT}();
      _;
   }
 

   function testFundOnlyOwnerCanWihtdraw() public funded {
      vm.prank(USER);
      fundMe.fund{value: SEND_AMOUNT}();
      
      vm.prank(USER);
      vm.expectRevert();
      fundMe.withdrawal();
   }

   function testFundArrayOfFunders() public funded {
      address funder = fundMe.getFunders(0);
      assertEq(funder, USER);
   }
 
}