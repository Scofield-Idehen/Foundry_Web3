//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/fundme.sol";

contract fundFundme is Script{
    uint constant SEND_Value = 0.01 ether;

    function fundFund(address mostrecentlydeployed) public{
        vm.startBroadcast();
        FundMe (payable(mostrecentlydeployed)).fund{value: SEND_Value}();
        vm.stopBroadcast();
        console.log("Funded the account with %s", SEND_Value);
    }

    function run() external {
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        fundFund(mostRecentDeployed); 

    }
}

contract withwithdraw is Script{

}