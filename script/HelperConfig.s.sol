// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;
 
import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";
 
contract HelperConfig is Script {
 
    uint8 public DECIMALS = 8;
    int256 public INITIAL_PRICE = 200e8;
 
    NetworkConfig public activeNetworkConfig;
 
    struct NetworkConfig {
        address priceFeed; //ETH/USD priceFeed address
    }
 
    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        }
        else if (block.chainid == 5){
            activeNetworkConfig = getGoerliConfig();
        }
        else if (block.chainid == 1){
            activeNetworkConfig = getMainnetEthConfig();
        }
        else {
            activeNetworkConfig = getAnvilConfig();
        }
    }
 