// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;
 
import {Test, console} from "forge-std/Test.sol";
import {console} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";
 
contract FundMeTest is Test {
 
    FundMe fundMe;
 
 function setUp() external {
    DeployFundMe deployFundMe = new DeployFundMe();
    fundMe = deployFundMe.run();
 }

 function testMinimumUsdIsFive() public view {
    uint256 minUsd = fundMe.MINIMUM_USD();
    assertEqUint(minUsd, 5*10**18);
 }

   function testFundFailsWithoutEnoughEth() public {
        vm.expectRevert();
        fundMe.fund();
    }
}