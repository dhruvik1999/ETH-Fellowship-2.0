// SPDX-License-Identifier: GPL-3.0
    
pragma solidity >=0.4.22 <0.8.0;
import "remix_tests.sol"; // this import is automatically injected by Remix.
import "remix_accounts.sol";
import "../contracts/1_Storage.sol";

// File name has to end with '_test.sol', this file can contain more than one testSuite contracts
contract testSuite {
    
    //Contract instance
    Storage cnt;
    //Contract address
    address addr = 0xd2a5bC10698FD955D1Fe6cb468a17809A08fd005;

    /// 'beforeAll' runs before all other tests
    /// More special functions are: 'beforeEach', 'beforeAll', 'afterEach' & 'afterAll'
    function beforeAll( ) public {
        // Here should instantiate tested contract
        cnt = Storage(addr);
        // Assert.equal(cnt.retrieve(),uint256(0),"Initial Retrived value should be 0");
    }

    //check for one store-retrive call
    function test_1() public  {
        uint256 inti_amnt = uint256(100);
        
        cnt.store( inti_amnt );
        Assert.equal( cnt.retrieve() , inti_amnt , "Stored amount should be equal to Retrived amount." );
    }
    
    //Check the contract multiple time uisng same stored values
    function test_2() public{
        
        uint256 total_test = 5;
        uint256 itr = 0;
        uint256 inti_amnt = uint256(150);
        
        for(itr=0;itr<total_test;itr+=1){
            
            cnt.store( inti_amnt );
            Assert.equal( cnt.retrieve() , inti_amnt , "Stored amount should be equal to Retrived amount." );
            
        }

    }
    // check the contract with multiple store and single retrive calls
    // to cehck readers-writers problem
    function test_3() public{
        
        uint256 total_test = 5;
        uint256 itr = 0;
        uint256 inti_amnt = uint256(150);
        
        for(itr=0;itr<total_test;itr+=1){
            inti_amnt+=1;
            cnt.store( inti_amnt );
            inti_amnt+=1;
            cnt.store( inti_amnt );
            inti_amnt+=1;
            cnt.store( inti_amnt );
            
            //Check the latest value stored
            Assert.equal( cnt.retrieve() , inti_amnt , "readers-writers problem, (latest stored amount should be equal to retrived amount.)" );
        }
        
    }
    
  
    // function checkFailure() public {
    //     Assert.equal(uint(1), uint(2), "1 is not equal to 2");
    // }

    /// Custom Transaction Context
    /// See more: https://remix-ide.readthedocs.io/en/latest/unittesting.html#customization
    /// #sender: account-1
    /// #value: 100
    function checkSenderAndValue() public payable {
        // account index varies 0-9, value is in wei
        Assert.equal(msg.sender, TestsAccounts.getAccount(1), "Invalid sender");
        Assert.equal(msg.value, 100, "Invalid value");
    }
}
