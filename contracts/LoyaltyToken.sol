//SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract LoyaltyToken is ERC20 {
    // data schema
    struct Member {
        address memberAddress;
        string name;
        string email;
        uint tokenCount;
        bool isRegistered;
    }

    struct Partner {
        address partnerAddress;
        string name;
        bool isRegistered;
        uint tokenCount;
    }

    struct Transaction {
        uint amount;
        string transactionType;
        address from;
        address to;
        string fromName;
        string toName;
        string date;
        string time;
    }


    address payable public owner;
    uint public maxTokenToMember = 4;
    uint public maxTokenToPartner = 500;
    uint public maxRedeemedToken = 15;

    constructor() ERC20("LoyaltyToken", "LOT") {
        owner = payable(msg.sender);
        _mint(owner, 100000000 * 10 ** decimals());
    }

    //members and partners on the network mapped with their address
    mapping(address => Member) public members;
    mapping(address => Partner) public partners;
    //mapping of Member's transactions
    mapping(address => Transaction[]) public memberTransaction;
    

    //mapping of Partner's transactions
    mapping(address => Transaction[]) public partnerTransaction;

    function balanceOfAccount(address _account) public view returns (uint) {
        return balanceOf(_account);
    }

    function registerMember (string memory _name, string memory _email) public {
      require(msg.sender != address(0),"Request must not originate from a zero account");
      require(!members[msg.sender].isRegistered, "Account already registered as Member");
      require(!partners[msg.sender].isRegistered, "Account already registered as Partner");
      members[msg.sender] = Member(msg.sender, _name, _email, 0, true);
    }

    //register sender as partner
    function registerPartner (string memory _name) public {
      require(msg.sender != address(0),"Request must not originate from a zero account");
      require(!members[msg.sender].isRegistered, "Account already registered as Member");
      require(!partners[msg.sender].isRegistered, "Account already registered as Partner");
      partners[msg.sender] = Partner(msg.sender, _name, true,0);
    }

    // token issued to the Partner
    function issueTokenToPartner(uint amount,string memory date,string memory time) external {
        require(msg.sender != address(0),"Request must not originate from a zero account");
        require(partners[msg.sender].isRegistered,"partner is not registerd");
        require(balanceOf(owner) >= amount,"Insufficient balance in faucet for withdrawal request");
        require(amount <= maxTokenToPartner,"more than maximum token cannot be issued at once");
        _transfer(owner, msg.sender, amount*10 ** decimals() );
        partners[msg.sender].tokenCount += amount;
        partnerTransaction[msg.sender].push(Transaction(amount,"issued",owner,msg.sender,"Flipkart",partners[msg.sender].name,date,time));
    } 

    // earned token when ever he/she make a purchase from the flipkart
    function earnedTokenByMember(uint amount,string memory date,string memory time) external {
        require(msg.sender != address(0),"Request must not originate from a zero account");
        require(members[msg.sender].isRegistered,"member is not registerd");
        require(balanceOf(owner) >= amount,"Insufficient balance in faucet for withdrawal request");
        require(amount <= maxTokenToMember,"more then maximum token cannot be issued at once");

        _transfer(owner, msg.sender, amount*10 ** decimals() );
        members[msg.sender].tokenCount+= amount;
        memberTransaction[msg.sender].push(Transaction(amount,"earned",owner,msg.sender,"Flipkart",members[msg.sender].name,date,time));
 
    } 

    // token given by the partner to the member 
    function partnerToMember(address member, uint amount,string memory date,string memory time ) public {
        require(msg.sender != address(0),"Request must not originate from a zero account");
        require(member != address(0),"Request must not originate from a zero account");
        require(balanceOf(msg.sender) >= amount,"Insufficient balance in faucet for withdrawal request");
        require(amount <= maxTokenToMember,"maximum of 4 token can be issued at once");

        _transfer(msg.sender, member, amount*10 ** decimals() );
        partners[msg.sender].tokenCount -= amount;
        members[member].tokenCount += amount;
        memberTransaction[member].push(Transaction(amount,"earned",msg.sender,member,partners[msg.sender].name,members[member].name,date,time));
        partnerTransaction[msg.sender].push(Transaction(amount,"givenToMemeber",msg.sender,member,partners[msg.sender].name,members[member].name,date,time));
    }

    // redeemed of token for the discount;
    function redeemedTokenMember(uint amount,string memory date,string memory time) public{
        require(msg.sender != address(0),"Request must not originate from a zero account");
        require(balanceOf(msg.sender) >= amount,"Insufficient balance in faucet for withdrawal request");
        require(amount <= maxRedeemedToken, "only maxRedeemed tokens can be redeemed at once");
        
        _transfer(msg.sender,owner, amount*10 ** decimals() );
        members[msg.sender].tokenCount-=amount;
        memberTransaction[msg.sender].push(Transaction(amount,"redeemed",msg.sender,owner,members[msg.sender].name,"Flipkart",date, time ));
    }

    function getPartnerTransactions(address _partnerAddress) public view returns (Transaction[] memory) {
        return partnerTransaction[_partnerAddress];
    }
    function getMemberTransactionsEarned(address _memberAddress) public view returns (Transaction[] memory) {
        return memberTransaction[_memberAddress];
    }
}
