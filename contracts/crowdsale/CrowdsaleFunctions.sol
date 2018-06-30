pragma solidity 0.4.17;

import './Crowdsale.sol';
import './AutoCoinToken.sol';
import '../math/SafeMath.sol';

contract CrowdsaleFunctions is Crowdsale {

 /** 
  * function bountyFunds - Transfer bounty tokens via AirDrop
  * @param beneficiary address where owner wants to transfer tokens
  * @param tokens value of token
  */

  function bountyFunds(address[] beneficiary, uint256[] tokens) onlyOwner public {
    for (uint256 i = 0; i < beneficiary.length; i++) {
      tokens[i] = SafeMath.mul(tokens[i],1 ether); 
      require(bountySupply >= tokens[i]);
      bountySupply = SafeMath.sub(bountySupply,tokens[i]);
      token.mint(beneficiary[i], tokens[i]);
    }
  }


  /** 
  * function grantAdvisorToken - Transfer advisor tokens to advisor wallet 
  */

  function grantAdvisorToken() onlyOwner public {

    require(!grantAdvisorSupply);
    require(advisorSupply > 0);
      token.mint(0x0000000000000000000000000000000000000000, advisorSupply);
  }

  /** 
   * function grantFounderTeamToken - Transfer advisor tokens to Founder and Team wallets 
   */

  function grantFounderTeamToken() onlyOwner public {

    require(!grantFounderTeamSupply);
    require(now > founderTeamTimeLock);
    require(founderSupply > 0);

    token.mint(0x0000000000000000000000000000000000000000, founderSupply);
    token.mint(0x0000000000000000000000000000000000000000, teamSupply);

    grantFounderTeamSupply = true;
    founderSupply = 0;
    teamSupply = 0;
 
  }

/** 
 *.function transferToken - Used to transfer tokens to investors who pays us other than Ethers
 * @param beneficiary - Address where owner wants to transfer tokens
 * @param tokens -  Number of tokens
 */
  function transferToken(address beneficiary, uint256 tokens) onlyOwner public {

    require(publicSupply > 0);
    tokens = SafeMath.mul(tokens,1 ether);
    require(publicSupply >= tokens);
    publicSupply = SafeMath.sub(publicSupply,tokens);
    token.mint(beneficiary, tokens);

  }

}