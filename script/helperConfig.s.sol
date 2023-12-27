//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/mockprice.sol";

contract help_config is Script{
    networkConfig public ssapolia;

    uint8 public constant DECIMAL = 8;
    int256 public constant PRICE = 2000e8;

    struct networkConfig{
        address priceFeed;
    }
    //if local use local address
    //if main use main address   this is our project today

    constructor() {
        if (block.chainid == 11155111) {
            ssapolia = getSapolia();
        } else if (block.chainid == 1) {
            ssapolia = getMainet();
        } else {
            ssapolia = getAnyotherAddress();}
    }

    function getSapolia() public pure returns (networkConfig memory){
        networkConfig memory sapolia = networkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return sapolia;
    }

    function getMainet() public pure returns (networkConfig memory){
        networkConfig memory ethmainet = networkConfig({priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419});
        return ethmainet;
    }

    function getAnyotherAddress() public returns (networkConfig memory){

        if (ssapolia.priceFeed != address(0)){
            return ssapolia;
        }

        vm.startBroadcast();
        MockV3Aggregator aggredPrice = new MockV3Aggregator(DECIMAL, PRICE);
        vm.stopBroadcast();

        networkConfig memory anvil = networkConfig({priceFeed: address(aggredPrice)});
        return anvil;
        
    }



}