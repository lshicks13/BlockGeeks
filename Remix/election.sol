//pragma experimental ABIEncoderV2;
pragma solidity ^0.4.0;


contract Election {
    //custom data type is a struct
    struct Candidate {
        string name;
        uint voteCount;
    }
    
    struct Voter {
        bool voted;
        uint vote;
        uint weight;
    }
   
   string public name; 
    address public owner;
    mapping(address => Voter) public voters;
    Candidate[] public candidates;
    
    event ElectionResult(string name, uint voteCount);
    
    constructor (string _name, /*string[] names*/ string name1, string name2) public {
        owner = msg.sender;
        name = _name;
        
        candidates.push(Candidate({name: name1, voteCount: 0}));
        candidates.push(Candidate({name: name2, voteCount: 0}));
    }
    
    function authorize(address voter) public {
        require(msg.sender == owner);
        require(!voters[voter].voted);
        
        voters[voter].weight = 1;
    }
    
    function vote(uint voteIndex) public {
        require(!voters[msg.sender].voted);
        
        voters[msg.sender].vote = voteIndex;
        voters[msg.sender].voted = true;
        
        candidates[voteIndex].voteCount += voters[msg.sender].weight;
    }
    
    function end() public {
        require(msg.sender == owner);
        
        for(uint i=0; i < candidates.length; i++){
            emit ElectionResult(candidates[i].name, candidates[i].voteCount);
        }
        
        selfdestruct(owner);
    }
}