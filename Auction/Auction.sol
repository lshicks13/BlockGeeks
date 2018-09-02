pragma solidity ^0.4.0;


interface Auction {
    
    function bid() external payable;
    
    function end() external;
}