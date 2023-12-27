//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/fundme.sol";
import {FUNDME_SCRIPT} from "../script/Fundme.s.sol";


contract Funs is Test{
    FundMe sundme;
    address USER = makeAddr ("Scofield");
    uint constant freeNumber = 0.1 ether;
    uint constant STARTING_BAL = 10 ether;

    function setUp() external {
        //sundme = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        FUNDME_SCRIPT script = new FUNDME_SCRIPT();
        sundme = script.run();
        vm.deal(USER, STARTING_BAL);
    }

    function testforValue() public {
        assertEq(sundme.MINIMUM_USD(), 5e18);
    }

    // test muat be public and must start the function or it will not run
    function testOwner() public {
        console.log(sundme.getOwner());
        console.log(msg.sender);

        //this does not check if the owner is msg.sender but it checks if the owner is the contract
        //assertEq(sundme.i_owner(), msg.sender);
        assertEq(sundme.getOwner(), msg.sender);
    }

    function testgo() public {
        uint version = sundme.getVersion(); 
        assertEq(version, 4);
    }

    function testfailedfund () public {
        //expect revert means a diffrent call that allows calls to fail which means they pass 
        vm.expectRevert(); // meaning next line should fail or the test fail
        sundme.fund();
    }

    //GitHub Copilot: This Solidity test function `whocallsthetest()` is doing the following:
    //It calls the `fund` function of the `sundme` contract with a value of `10e18` (which is equivalent to 1 Ether if we're talking about wei, the smallest unit of Ether).
    //It retrieves the amount funded by the sender (the account that called this function) using the `getaddresstofund` function of the `sundme` contract.
    //It asserts that the amount funded by the sender is equal to `10e18` using the `assertEq` function. If the amount funded is not equal to `10e18`, the test will fail.
    //So, in summary, this test is checking that the `fund` function of the `sundme` contract correctly updates the amount funded by the sender.

     function testwhocallsthetest() public {
        vm.prank(USER);
        sundme.fund{value: freeNumber}();

        uint256 amountvalue = sundme.getaddresstofund(USER);
        assertEq(amountvalue, freeNumber);
    } 

    modifier blackhole (){
        //patrick adds the vm.prank(USER) to the testonlyownervalues but i do not 
        vm.prank(USER);
        sundme.fund{value: freeNumber}();
        _;
    }

    function testonlyownervalues() public blackhole {
        vm.expectRevert();
        sundme.withdraw();
    }

    function testFunderfile() public blackhole{
        //Arrange
        uint firstbalance = sundme.getOwner().balance;
        uint startingmoney = address(sundme).balance;

        //Act
        vm.prank(sundme.getOwner());
        sundme.withdraw();

        //assert

        uint endingownerbal = sundme.getOwner().balance;
        uint endiingbal = address(sundme).balance;

        assertEq(endiingbal, 0);
        assertEq(startingmoney + firstbalance, endingownerbal);
    }


    function testwithdraw() public blackhole{
        uint160 numberoffunders = 10;
        uint160 startingfunding = 1;

        for(uint160 i = startingfunding; i < numberoffunders; i++){


            hoax(address(i), freeNumber);
            sundme.fund{value: freeNumber};
        }

        uint endingownerbal = sundme.getOwner().balance;
        uint endiingbal = address(sundme).balance;

        vm.startPrank(sundme.getOwner());
        sundme.withdraw();
        vm.stopPrank();

        assertEq(address(sundme).balance == 0);
        assertEq(endiingbal + endingownerbal == sundme.getOwner().balance);

    }
}