//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/fundme.sol";
import {help_config} from "./helperConfig.s.sol";


contract FUNDME_SCRIPT is Script{



    function run() external returns (FundMe) {

        // this means we wont spend more gas for this new contract as it will be ran internally 
        help_config config = new help_config();
        address ethusd = config.ssapolia();

        vm.startBroadcast();
        FundMe fundMe = new FundMe(ethusd);
        vm.stopBroadcast();
        return fundMe;
    }

}