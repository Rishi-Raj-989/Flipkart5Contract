const { expect } = require("chai");
const  hre  = require("hardhat");

describe("LoyaltyToken", function () {
  let LoyaltyToken;
  let loyaltyToken;

  beforeEach(async function () {
    LoyaltyToken = await hre.ethers.getContractFactory("LoyaltyToken");
    loyaltyToken = await LoyaltyToken.deploy();
    await loyaltyToken.deployed();
  });

  it("should register a member", async function () {
    const [owner, member] = await hre.ethers.getSigners();

    await loyaltyToken.connect(member).registerMember("John", "john@example.com");
    
    const memberInfo = await loyaltyToken.members(member.address);
    expect(memberInfo.isRegistered).to.equal(true);
    expect(memberInfo.name).to.equal("John");
    expect(memberInfo.email).to.equal("john@example.com");
  });

//   it("should issue tokens to a partner", async function () {
//     const [owner, partner] = await hre.getSigners();

//     await loyaltyToken.connect(partner).registerPartner("Flipkart");
//     await loyaltyToken.connect(owner).issueTokenToPartner(partner.address, 100);

//     const partnerInfo = await loyaltyToken.partners(partner.address);
//     expect(partnerInfo.isRegistered).to.equal(true);
//     expect(partnerInfo.tokenCount).to.equal(100);

//     const partnerBalance = await loyaltyToken.balanceOf(partner.address);
//     expect(partnerBalance).to.equal(100 * 10 ** 18);
//   });

//   // ...

// it("should allow a member to earn tokens from a partner", async function () {
//     const [owner, partner, member] = await hre.getSigners();
  
//     await loyaltyToken.connect(partner).registerPartner("Flipkart");
//     await loyaltyToken.connect(member).registerMember("John", "john@example.com");
  
//     // Issue tokens to the partner
//     await loyaltyToken.connect(owner).issueTokenToPartner(partner.address, 100);
  
//     // Simulate member earning tokens from the partner
//     await loyaltyToken.connect(partner).earnedTokenByMember(50, member.address, 100);
  
//     const memberInfo = await loyaltyToken.members(member.address);
//     expect(memberInfo.tokenCount).to.equal(50);
  
//     const partnerLoyalMemberInfo = await loyaltyToken.partnerLoyalMembers(partner.address, member.address);
//     expect(partnerLoyalMemberInfo.isRegistered).to.equal(true);
//     expect(partnerLoyalMemberInfo.totalAmountSpend).to.equal(100);
//   });
  
//   it("should allow a partner to give tokens to a member", async function () {
//     const [owner, partner, member] = await hre.getSigners();
  
//     await loyaltyToken.connect(partner).registerPartner("Flipkart");
//     await loyaltyToken.connect(member).registerMember("John", "john@example.com");
  
//     // Issue tokens to the partner
//     await loyaltyToken.connect(owner).issueTokenToPartner(partner.address, 100);
  
//     // Partner gives tokens to a member
//     await loyaltyToken.connect(partner).partnerToMember(member.address, 30);
  
//     const partnerInfo = await loyaltyToken.partners(partner.address);
//     expect(partnerInfo.tokenCount).to.equal(70);
  
//     const memberInfo = await loyaltyToken.members(member.address);
//     expect(memberInfo.tokenCount).to.equal(30);
//   });
  
//   it("should allow a member to redeem tokens for discount", async function () {
//     const [owner, member] = await hre.getSigners();
  
//     await loyaltyToken.connect(member).registerMember("John", "john@example.com");
  
//     // Issue tokens to the member
//     await loyaltyToken.connect(owner).transfer(member.address, 50 * 10 ** 18);
  
//     // Member redeems tokens for discount
//     await loyaltyToken.connect(member).redeemedTokenMember(10);
  
//     const memberInfo = await loyaltyToken.members(member.address);
//     expect(memberInfo.tokenCount).to.equal(40);
  
//     const ownerBalance = await loyaltyToken.balanceOf(owner.address);
//     expect(ownerBalance).to.equal(10 * 10 ** 18);
//   });
  

  

});
