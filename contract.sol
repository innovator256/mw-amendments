contract BoardRoom {
    function getProposalBytes(uint _pid,bytes32 _param) returns (bytes32 b){}
    function getProposalUint(uint256 _pid,bytes32 _param) returns (uint256 u){}
    function getProposalExecuted(uint256 _pid) returns (bool b){}
    function hasWon(uint256 _pid) returns (bool ){}
    
    
    function getDelegationNumDelegations(uint256 _pid,uint256 _to) returns (uint256 u){}
    function getDelegationType(uint256 _pid,uint256 _to) returns (bool b){}
    
    
    function getMemberUint(uint256 _mid,bytes32 _param) returns (uint256 u){}
    function numMembersActive() constant returns (uint256 ){}
    function getMemberAddress(uint256 _mid) returns (address a){}
    function toMember(address ) constant returns (uint256 ){}
    function chair() constant returns (uint256 ){}
    
    
    function numExecuted() constant returns (uint256 ){}
    function numProposals() constant returns (uint256 ){}
    function numMembers() constant returns (uint256 ){}
    function numChildrenActive() constant returns (uint256 ){}
    function numChildren() constant returns (uint256 ){}
    function configAddr() constant returns (address ){}
    
    
    function parent() constant returns (address ){}
    function children(uint256 ) constant returns (address ){}
}

contract Amendments {
    struct Ammendment {
        uint to;
        uint instanceExpiry;
        uint created;
    }
    
    mapping(address => mapping(address => mapping(uint => Ammendment))) ammendments;
    
    function ammend(address _boardroomAddress, uint _pid, uint _to) {
        Ammendment a = ammendments[msg.sender][_boardroomAddress][_pid];
        
        uint proposalFrom = BoardRoom(_boardroomAddress).getProposalUint(_pid, "from");
        uint proposalNumVotes = BoardRoom(_boardroomAddress).getProposalUint(_pid, "from");
        address memberAddress = BoardRoom(_boardroomAddress).getMemberAddress(proposalFrom);
        
        if(a.created != 0 || proposalNumVotes > 0 || memberAddress != msg.sender)
            return;
            
        a.to = _to;
        a.created = now;
        a.instanceExpiry = now + (30 days);
    }
    
    function removeAmmendment(address _boardroomAddress, uint _pid) {
        Ammendment a = ammendments[msg.sender][_boardroomAddress][_pid];
        
        uint proposalFrom = BoardRoom(_boardroomAddress).getProposalUint(_pid, "from");
        uint proposalNumVotes = BoardRoom(_boardroomAddress).getProposalUint(_pid, "from");
        address memberAddress = BoardRoom(_boardroomAddress).getMemberAddress(proposalFrom);
        
        if(a.created == 0 || proposalNumVotes > 0 || a.instanceExpiry > now)
            return;
            
        delete ammendments[msg.sender][_boardroomAddress][_pid];
    }
}   
