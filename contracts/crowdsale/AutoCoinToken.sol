pragma solidity 0.4.17;

/**
 * @title AutoCoinToken 
 */
 
import '../token/MintableToken.sol';


contract AutoCoinToken is MintableToken {

  /**
   *  @string name - Token Name
   *  @string symbol - Token Symbol
   *  @uint8 decimals - Token Decimals
   *  @uint256 _totalSupply - Token Total Supply
  */

  string public constant name = "AUTO COIN";
  string public constant symbol = "AUTO COIN";
  uint8 public constant decimals = 18;
  uint256 public constant _totalSupply = 400000000 * 1 ether;
  
/** Constructor AutoCoinToken */
  function AutoCoinToken() {
    totalSupply = _totalSupply;
  }

}


