pragma solidity ^0.4.0;

import "./Auction.sol";

contract baseAuction is Auction {
    
    address public owner;
    
    modifier ownerOnly() {
        require(msg.sender == owner);
        _;
    }
    
    event auctionComplete(address winner, uint bid);
    
    constructor() public {
        owner = msg.sender;
    }
}