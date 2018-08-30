pragma solidity 0.4.24;

contract SimpleCounter {
    int256 counter; // state variable
    address owner;
    
    constructor() public {
        counter = 0;
        owner =msg.sender;
    }
    
    function getCounter() view public returns(int) {
        return counter;
    }
    
    function increment() public { //payable public - to make them pay for incrementing
        //require(msg.value > 0.1 ether); // input conditional checks (require())
        counter += 1;
    }
    
    function decrement() public {
        counter -= 1;
    }
    
    function reset() public {
        require(msg.sender == owner);
        counter = 0;
    }
}