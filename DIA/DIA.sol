pragma solidity ^0.4.24;

contract SafeMath {
    function safeAdd(uint a, uint b) public pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
    function safeSub(uint a, uint b) public pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }
    function safeMul(uint a, uint b) public pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
    function safeDiv(uint a, uint b) public pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
}

contract DIA is SafeMath{
    
    uint256 prev_block_number=0;
    uint256 curr_block_number=0;
    
    uint256 _totalSupply = 10000000000000000000000000;
    
    address owner;
    address second_owner;
    
    mapping(address => uint) balances;
    
    constructor() public{
        owner = msg.sender;
        balances[owner] = _totalSupply;
        
    }
    
    function setSecondOwner(address addr) public{
        require(msg.sender == owner , "Only owner can set the second owner.");
        second_owner = addr;
    }
    
    function stayAlive() public returns(uint) {
        require(msg.sender==owner , "Only owner can call stayAlive function");
        prev_block_number = block.number;
        return block.number;
    }
    
    function checkIsDead() public returns (bool){
        curr_block_number = block.number;
        if( (curr_block_number - prev_block_number ) > 10 ){
            afterOwnerDead();
            return true;   
        }else{
            return false;
        }
    }
    
    function afterOwnerDead() private{
        transferAll();
        owner = second_owner;
    }
    
    function transferAll() private {
        balances[second_owner] = safeAdd( balances[second_owner] , balances[owner] );
        balances[owner] = 0;
    }
    
    function balanceOf(address tokenOwner) public constant returns (uint balance) {
        return balances[tokenOwner];
    }
    
}