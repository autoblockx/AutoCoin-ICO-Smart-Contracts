pragma solidity 0.4.17;

/**
 * @title AutoCoinICO
 * @dev AutoCoinCrowdsale is a base contract for managing a token crowdsale.
 * Crowdsales have a start and end timestamps, where investors can make
 * token purchases and the crowdsale will assign them ATC tokens based
 * on a ATC token per ETH rate. Funds collected are forwarded to a wallet
 * as they arrive.
 */

import './Crowdsale.sol';
import './CappedCrowdsale.sol';
import './RefundableCrowdsale.sol';
import './AutoCoinToken.sol';
import '../math/SafeMath.sol';
import './CrowdsaleFunctions.sol';

contract AutoCoinICO is Crowdsale, CappedCrowdsale, RefundableCrowdsale, CrowdsaleFunctions {
  
    /** Constructor AutoCoinICO */
    function AutoCoinICO(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _goal, uint256 _cap, address _wallet) 
    CappedCrowdsale(_cap)
    FinalizableCrowdsale()
    RefundableCrowdsale(_goal)   
    Crowdsale(_startTime,_endTime,_rate,_wallet) 
    {
        require(_goal < _cap);
    }
    
    /** AutoCoinToken Contract */
    function createTokenContract() internal returns (MintableToken) {
        return new AutoCoinToken();
    }


}