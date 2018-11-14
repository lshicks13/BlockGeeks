pragma solidity ^0.4.0;

contract Escrow {
    
    enum State {AWAITING_PAYMENT, AWAITING_DELIVERY, COMPLETE, REFUNDED}
    State public currentState;
    
    modifier buyerOnly() {
        require(msg.sender == buyer || msg.sender == arbiter);
        _;
    }
    
    modifier sellerOnly() {
        require(msg.sender == seller || msg.sender == arbiter);
        _;
    }
    
    modifier inState(State expectedState) {
        require(currentState == expectedState);
        _;
    }
    address public Contract;
    address public buyer;
    address public seller;
    address public arbiter;
    
    constructor(address _buyer, address _seller, address _arbiter) public {
        buyer = _buyer;
        seller = _seller;
        arbiter = _arbiter;
        Contract = this;
    }
    
    function confirmPayment() buyerOnly inState(State.AWAITING_PAYMENT) public payable {
        //require(msg.sender == buyer); replaced by the buyerOnly modifier
        //require(currentState == State.AWAITING_PAYMENT); replaced by the inState modifier
        currentState = State.AWAITING_DELIVERY;
    }
    
    function confirmDelivery() buyerOnly inState(State.AWAITING_DELIVERY) public {
        //require(msg.sender == buyer || msg.sender == arbiter); replaced by the buyerOnly modifier
        //require(currentState == State.AWAITING_DELIVERY); replaced by the inState modifier
        seller.transfer(address(Contract).balance);
        currentState = State.COMPLETE;
    }
    
    function refundBuyer() sellerOnly inState(State.AWAITING_DELIVERY) public {
        //require(msg.sender == seller || msg.sender == arbiter); replaced by the sellerOnly modifier
        //require(currentState == State.AWAITING_DELIVERY); replaced by the inState modifier
        buyer.transfer(address(Contract).balance);
        currentState = State.REFUNDED;
    }
}