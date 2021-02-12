pragma solidity ^0.4.24;

contract multiSignWallet{
    address private _owner;
    uint256 private totalOwners;
    uint256 private THR_REQ_SIGN;
    uint256 private ttlTx;
    
    mapping(address=>uint) allOwners;
    
    modifier isOwner(){
        require(msg.sender == _owner , "Owner can execute this function");
        _;
    }
    
    modifier isValidator(){
        require(allOwners[msg.sender]==1);
        _;
    }
    
    constructor() public{
        _owner = msg.sender;
        allOwners[_owner]=1;
        totalOwners=1;
        ttlTx=0;
    }
    
    function addOwner( address newOwner ) isOwner public{
        require(allOwners[newOwner]==0);
        allOwners[newOwner]=1;
        totalOwners+=1;
    }
    
    function removeOwner( address oldOwner ) isOwner public{
        allOwners[oldOwner]=0;
        totalOwners-=1;
    }
    
    function getTotalOwners() view public returns(uint256){
        return totalOwners;
    }
    
    function setThresholdForSignatures(uint256 n) isOwner public{
        require(n<=totalOwners,"Threshold should be less than number of validators");
        THR_REQ_SIGN = n;
    }
    
    function deposite() payable public{
        
    }
    
    function Balance() view public returns(uint){
        return address(this).balance;
    }
    
    event e_pendingTransaction(address from, address to, uint256 amount, uint256 transactionId);
    event e_signTransaction(address signers, uint256 transactionId);
    event e_transaction(address from, address to, uint256 amount, uint256 transactionId);
    
    struct Transaction{
        address from;
        address to;
        uint256 amount;
        uint256 signCnt;
        mapping(address=>uint) signers; 
        bool done;
    }
    
    mapping(uint256=>Transaction) allTx;
    
    function transact( address to , uint256 amount  ) isValidator public {
        require(amount <= address(this).balance , "Amount should be less than available balance.");
        ttlTx+=1;
        
        Transaction memory tx;
        tx.from = msg.sender;
        tx.to = to;
        tx.amount = amount;
        tx.signCnt=0;
        tx.done=false;
        
        allTx[ttlTx]=tx;
        
        emit e_pendingTransaction(msg.sender,to,amount,ttlTx);
    }
    
    function withdraw(uint256 amount) isValidator public{
        transact(msg.sender , amount);
    }
    
    function signTransaction(uint256 transactionId) isValidator public{
        Transaction storage tx = allTx[transactionId];
        
        require( tx.signers[msg.sender]==0 , "Validators can only sign once." );
        require(tx.done == false , "Transaction is completed");
        
        tx.signers[msg.sender]=1;
        tx.signCnt+=1;
        
        emit e_signTransaction(msg.sender , transactionId);
        
        if(tx.signCnt>=THR_REQ_SIGN){
            require(address(this).balance >= tx.amount);
            tx.to.transfer(tx.amount);
            tx.done=true;
            emit e_transaction(tx.from, tx.to, tx.amount, transactionId);
        }
    }
    
    
    
    
}