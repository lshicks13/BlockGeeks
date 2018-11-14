pragma solidity ^0.4.0;

import "./baseAuction.sol";
import "./withdrawable.sol";

contract timerAuction is baseAuction, withdrawable {
    
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
        //make sure auction hasnt already ended
        require(now < auctionEnd);
        //make sure bid is higher than current max
        require(msg.value > maxBid);
        
        //return the bid amount that got beat
        if(maxBidder != 0) {
            //WARNING: THIS IS UNSAFE!
            //maxBidder.transfer(maxBid);
            pendingWithdrawals[maxBidder] = maxBid;
        }
        
        //update new max bidder
        maxBidder = msg.sender;
        maxBid = msg.value;
        emit bidAccepted(maxBidder, maxBid);
    }
    
    function end() ownerOnly public {
        //1) check conditions
        //make sure this function only called once
        require(!ended);
        //make sure owner cant declare winner before time is up
        require(now >= auctionEnd);
        
        //2) update state
        //set the flag
        ended = true;
        //announce the winner
        emit auctionComplete(maxBidder, maxBid);
        
        //3) interact with an external contract
        //WARNING: THIS IS UNSAFE!
        //owner.transfer(maxBid);
        pendingWithdrawals[owner] = maxBid;
    }
}