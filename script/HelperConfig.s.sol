// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
 
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
 
    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig(
            {
                priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
            }
        );
        return sepoliaConfig;
    }
 
    function getMainnetEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory ethConfig = NetworkConfig(
            {
                priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
            }
        );
        return ethConfig;
        
    }
 
    function getGoerliConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory goerliConfig = NetworkConfig(
            {
                priceFeed: 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
            }
        );
        return goerliConfig;        
    }
 
    function getAnvilConfig()  public returns (NetworkConfig memory) {
        //Prevent from re-deploying a mock contract each time we call this function
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }
 
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();
 
        NetworkConfig memory anvilConfig = NetworkConfig(
            {
                priceFeed: address(mockPriceFeed)
            }
        );
        return anvilConfig;        
    }   
}   