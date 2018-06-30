pragma solidity 0.4.17;

import '../token/MintableToken.sol';
import '../math/SafeMath.sol';
import '../ownership/Ownable.sol';
import '../lifecycle/Pausable.sol';

/**
 * @title AutoCoin Crowdsale
 * @dev Crowdsale is a base contract for managing a token crowdsale.
 * Crowdsales have a start and end timestamps, where investors can make
 * token purchases and the crowdsale will assign them tokens based
 * on a token per ETH rate. Funds collected are forwarded to a wallet
 * as they arrive.
 */

contract Crowdsale is Ownable, Pausable {
  using SafeMath for uint256;

  /**
   *  @MintableToken token - Token Object
   *  @address wallet - Wallet Address
   *  @uint8 rate - Tokens per Ether
   *  @uint256 weiRaised - Total funds raised in Ethers
  */

  MintableToken internal token;
  address internal wallet;
  uint256 public rate;
  uint256 internal weiRaised;

  /**
   *  @uint256 privateSaleStartTime - Private-Sale Start Time
   *  @uint256 privateSaleEndTime - Private-Sale End Time
   *  @uint256 preSaleStartTime - Pre-Sale Start Time
   *  @uint256 preSaleEndTime - Pre-Sale End Time
   *  @uint256 preICOStartTime - Pre-ICO Start Time
   *  @uint256 preICOEndTime - Pre-ICO End Time
   *  @uint256 ICOstartTime - ICO Start Time
   *  @uint256 ICOEndTime - ICO End Time
  */
  
  uint256 public privateSaleStartTime;
  uint256 public privateSaleEndTime;
  uint256 public preSaleStartTime;
  uint256 public preSaleEndTime;
  uint256 public preICOStartTime;
  uint256 public preICOEndTime;
  uint256 public ICOstartTime;
  uint256 public ICOEndTime;
  
  /**
   *  @uint privateBonus - Private Bonus
   *  @uint preSaleBonus - Pre-Sale Bonus
   *  @uint preICOBonus - Pre-Sale Bonus
   *  @uint firstWeekBonus - ICO 1st Week Bonus
   *  @uint secondWeekBonus - ICO 2nd Week Bonus
   *  @uint thirdWeekBonus - ICO 3rd Week Bonus
   *  @uint forthWeekBonus - ICO 4th Week Bonus
   *  @uint fifthWeekBonus - ICO 5th Week Bonus
  */

  uint internal privateSaleBonus;
  uint internal preSaleBonus;
  uint internal preICOBonus;
  uint internal firstWeekBonus;
  uint internal secondWeekBonus;
  uint internal thirdWeekBonus;
  uint internal forthWeekBonus;
  uint internal fifthWeekBonus;
  
  /**
   *  @uint256 weekOne - WeekOne Time 
   *  @uint256 weekTwo - WeekTwo Time 
   *  @uint256 weekThree - WeekThree Time 
  */

  uint256 internal weekOne;
  uint256 internal weekTwo;
  uint256 internal weekThree;
  uint256 internal weekFour;
  uint256 internal weekFive;

  /**
   *  @uint256 totalSupply - Total supply of tokens 
   *  @uint256 publicSupply - Total public Supply 
   *  @uint256 bountySupply - Total Bounty Supply
   *  @uint256 teamSupply - Total Team Supply 
   *  @uint256 advisorSupply - Total Advisor Supply 
   *  @uint256 founderSupply - Total Founder Supply
   *  @uint256 privateSaleSupply - Total Private Supply from Public Supply  
   *  @uint256 preSaleSupply - Total PreSale Supply from Public Supply 
   *  @uint256 preICOSupply - Total PreICO Supply from Public Supply
   *  @uint256 icoSupply - Total ICO Supply from Public Supply
  */

  uint256 public totalSupply = SafeMath.mul(400000000, 1 ether);
  uint256 internal publicSupply = SafeMath.mul(SafeMath.div(totalSupply,100),55);
  uint256 internal teamSupply = SafeMath.mul(SafeMath.div(totalSupply,100),15);
  uint256 internal advisorSupply = SafeMath.mul(SafeMath.div(totalSupply,100),5);
  uint256 internal bountySupply = SafeMath.mul(SafeMath.div(totalSupply,100),6);
  uint256 internal founderSupply = SafeMath.mul(SafeMath.div(totalSupply,100),19);
  uint256 internal privateSaleSupply = SafeMath.mul(24750000, 1 ether);
  uint256 internal preSaleSupply = SafeMath.mul(39187500, 1 ether);
  uint256 internal preICOSupply = SafeMath.mul(39187500, 1 ether);
  uint256 internal icoSupply = SafeMath.mul(116875000, 1 ether);

  /**
   *  @uint256 advisorTimeLock - Advisor Timelock 
   *  @uint256 founderTeamTimeLock - Founder and Team Timelock 
  */

  uint256 internal advisorTimeLock;
  uint256 internal founderTeamTimeLock;

  /**
   *  @bool checkUnsoldTokens - Tokens will be added to bounty supply
   *  @bool upgradePreSaleSupply - Boolean variable updates when the PrivateSale tokens added to PreSale supply
   *  @bool upgradePreICOSupply - Boolean variable updates when the PreSale tokens added to PreICO supply
   *  @bool upgradeICOSupply - Boolean variable updates when the PreICO tokens added to ICO supply
   *  @bool grantAdvisorSupply -  Boolean variable updates when Team tokens minted
   *  @bool grantFounderTeamSupply - Boolean variable updates when Team and Founder tokens minted
  */

  bool internal checkUnsoldTokens;
  bool internal upgradePreSaleSupply;
  bool internal upgradePreICOSupply;
  bool internal upgradeICOSupply;
  bool internal grantAdvisorSupply;
  bool internal grantFounderTeamSupply;



  /**
   * event for token purchase logging
   * @param purchaser who paid for the tokens
   * @param beneficiary who got the tokens
   * @param value Wei's paid for purchase
   * @param amount amount of tokens purchased
   */

  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);

  /**
   * function Crowdsale - Parameterized Constructor
   * @param _startTime - StartTime of Crowdsale
   * @param _endTime - EndTime of Crowdsale
   * @param _rate - Tokens against Ether
   * @param _wallet - MultiSignature Wallet Address
   */

  function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) internal {
    
    require(_wallet != 0x0);

    token = createTokenContract();

    privateSaleStartTime = _startTime;
    privateSaleEndTime = 1534377599;
    preSaleStartTime = 1534377600;
    preSaleEndTime = 1537919999;
    preICOStartTime = 1537920000;
    preICOEndTime = 1541030399;
    ICOstartTime = 1541030400;
    ICOEndTime = _endTime;

    rate = _rate;
    wallet = _wallet;

    privateSaleBonus = SafeMath.div(SafeMath.mul(rate,50),100);
    preSaleBonus = SafeMath.div(SafeMath.mul(rate,30),100);
    preICOBonus = SafeMath.div(SafeMath.mul(rate,30),100);
    firstWeekBonus = SafeMath.div(SafeMath.mul(rate,20),100);
    secondWeekBonus = SafeMath.div(SafeMath.mul(rate,15),100);
    thirdWeekBonus = SafeMath.div(SafeMath.mul(rate,10),100);
    forthWeekBonus = SafeMath.div(SafeMath.mul(rate,5),100);
    

    weekOne = SafeMath.add(ICOstartTime, 14 days);
    weekTwo = SafeMath.add(weekOne, 14 days);
    weekThree = SafeMath.add(weekTwo, 14 days);
    weekFour = SafeMath.add(weekThree, 14 days);
    weekFive = SafeMath.add(weekFour, 14 days);

    advisorTimeLock = SafeMath.add(ICOEndTime, 180 days);
    founderTeamTimeLock = SafeMath.add(ICOEndTime, 180 days);

    checkUnsoldTokens = false;
    upgradeICOSupply = false;
    upgradePreICOSupply = false;
    upgradePreSaleSupply = false;
    grantAdvisorSupply = false;
    grantFounderTeamSupply = false;
  
  }

  /**
   * function createTokenContract - Mintable Token Created
   */

  function createTokenContract() internal returns (MintableToken) {
    return new MintableToken();
  }
  
  /**
   * function Fallback - Receives Ethers
   */

  function () payable {
    buyTokens(msg.sender);
  }

    /**
   * function preSaleTokens - Calculate Tokens in PreSale
   */

  function privateSaleTokens(uint256 weiAmount, uint256 tokens) internal returns (uint256) {
        
    require(privateSaleSupply > 0);

    tokens = SafeMath.add(tokens, weiAmount.mul(privateSaleBonus));
    tokens = SafeMath.add(tokens, weiAmount.mul(rate));

    require(privateSaleSupply >= tokens);

    privateSaleSupply = privateSaleSupply.sub(tokens);        

    return tokens;

  }


  /**
   * function preSaleTokens - Calculate Tokens in PreSale
   */

  function preSaleTokens(uint256 weiAmount, uint256 tokens) internal returns (uint256) {
        
    require(preSaleSupply > 0);

    tokens = SafeMath.add(tokens, weiAmount.mul(preSaleBonus));
    tokens = SafeMath.add(tokens, weiAmount.mul(rate));

    require(preSaleSupply >= tokens);

    preSaleSupply = preSaleSupply.sub(tokens);        

    return tokens;

  }

  /**
    * function preICOTokens - Calculate Tokens in PreICO
    */

  function preICOTokens(uint256 weiAmount, uint256 tokens) internal returns (uint256) {
        
    require(preICOSupply > 0);

    if (!upgradePreICOSupply) {
      preICOSupply = SafeMath.add(preICOSupply,preSaleSupply);
      upgradePreICOSupply = true;
    }

    tokens = SafeMath.add(tokens, weiAmount.mul(preICOBonus));
    tokens = SafeMath.add(tokens, weiAmount.mul(rate));
    
    require(preICOSupply >= tokens);
    
    preICOSupply = preICOSupply.sub(tokens);        

    return tokens;

  }

  /**
   * function icoTokens - Calculate Tokens in ICO
   */
  
  function icoTokens(uint256 weiAmount, uint256 tokens, uint256 accessTime) internal returns (uint256) {
        
    require(icoSupply > 0);

    if (!upgradeICOSupply) {
      icoSupply = SafeMath.add(icoSupply,preICOSupply);
      upgradeICOSupply = true;
    }
    
    if (accessTime <= weekOne) {
      tokens = SafeMath.add(tokens, weiAmount.mul(firstWeekBonus));
    } else if (accessTime <= weekTwo) {
      tokens = SafeMath.add(tokens, weiAmount.mul(secondWeekBonus));
    } else if ( accessTime < weekThree ) {
      tokens = SafeMath.add(tokens, weiAmount.mul(thirdWeekBonus));
    } else if ( accessTime < weekFour ) {
      tokens = SafeMath.add(tokens, weiAmount.mul(forthWeekBonus));
    } else if ( accessTime < weekFive ) {
      tokens = SafeMath.add(tokens, weiAmount.mul(fifthWeekBonus));
    }
    
    tokens = SafeMath.add(tokens, weiAmount.mul(rate));
    icoSupply = icoSupply.sub(tokens);        

    return tokens;

  }

  /**
  * function buyTokens - Collect Ethers and transfer tokens
  */

  function buyTokens(address beneficiary) whenNotPaused public payable {

    require(beneficiary != 0x0);
    require(validPurchase());

    uint256 accessTime = now;
    uint256 tokens = 0;
    uint256 weiAmount = msg.value;

    require((weiAmount >= (100000000000000000)) && (weiAmount <= (20000000000000000000)));

    if ((accessTime >= privateSaleStartTime) && (accessTime < privateSaleEndTime)) {
      tokens = preSaleTokens(weiAmount, tokens);
    } else if ((accessTime >= preSaleStartTime) && (accessTime < preSaleEndTime)) {
      tokens = preSaleTokens(weiAmount, tokens);
    } else if ((accessTime >= preICOStartTime) && (accessTime < preICOEndTime)) {
      tokens = preICOTokens(weiAmount, tokens);
    } else if ((accessTime >= ICOstartTime) && (accessTime <= ICOEndTime)) { 
      tokens = icoTokens(weiAmount, tokens, accessTime);
    } else {
      revert();
    }
    
    publicSupply = publicSupply.sub(tokens);
    weiRaised = weiRaised.add(weiAmount);
    token.mint(beneficiary, tokens);
    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
    forwardFunds();

  }

  /**
   * function forwardFunds - Transfer funds to wallet
   */

  function forwardFunds() internal {
    wallet.transfer(msg.value);
  }

  /**
   * function validPurchase - Checks the purchase is valid or not
   * @return true - Purchase is withPeriod and nonZero
   */

  function validPurchase() internal constant returns (bool) {
    bool withinPeriod = now >= privateSaleStartTime && now <= ICOEndTime;
    bool nonZeroPurchase = msg.value != 0;
    return withinPeriod && nonZeroPurchase;
  }

  /**
   * function hasEnded - Checks the ICO ends or not
   * @return true - ICO Ends
   */
  
  function hasEnded() public constant returns (bool) {
    return now > ICOEndTime;
  }

  /**
   * function unsoldToken - Function used to transfer all 
   *               unsold public tokens to reserve supply
   */

  function unsoldToken() onlyOwner public {
    require(hasEnded());
    require(!checkUnsoldTokens);
    
    checkUnsoldTokens = true;
    bountySupply = SafeMath.add(bountySupply, publicSupply);
    publicSupply = 0;

  }

  /** 
   * function getTokenAddress - Get Token Address 
   */

  function getTokenAddress() onlyOwner public returns (address) {
    return token;
  }

  /** 
   * function getPublicSupply - Get Public Address 
   */

  function getPublicSupply() onlyOwner public returns (uint256) {
    return publicSupply;
  }

}



