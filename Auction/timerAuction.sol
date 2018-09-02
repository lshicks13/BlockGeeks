pragma solidity ^0.4.0;

import "./baseAuction.sol";

contract timerAuction is baseAuction {
    
    string public item;
    uint public auctionEnd;
    address public maxBidder;
    uint public maxBid;
    bool public ended;
    
    event bidAccepted(address bidder, uint bid);
    
    constructor(uint _durationMinutes, string _item) public {
        item = _item;
        auctionEnd = now + (_durationMinutes * 1 minutes);
    }
    
    function bid() payable public {
        require(now < auctionEnd);
        require(msg.value > maxBid);
        
        if(maxBidder != 0) {
            maxBidder.transfer(maxBid);
        }
        
        maxBidder = msg.sender;
        maxBid = msg.value;
        emit bidAccepted(maxBidder, maxBid);
    }
    
    function end() ownerOnly public {
        //1) check conditions
        require(!ended);
        require(now >= auctionEnd);
        
        //2) update state
        ended = true;
        emit auctionComplete(maxBidder, maxBid);
        
        //3) interact with an external contract
        owner.transfer(maxBid);
    }
}