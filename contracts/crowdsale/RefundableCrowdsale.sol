pragma solidity 0.4.17;


import '../math/SafeMath.sol';
import './FinalizableCrowdsale.sol';
import './RefundVault.sol';


/**
 * @title RefundableCrowdsale
 * @dev Extension of Crowdsale contract that adds a funding goal, and
 * the possibility of users getting a refund if goal is not met.
 * Uses a RefundVault as the crowdsale's vault.
 */
contract RefundableCrowdsale is FinalizableCrowdsale {
  using SafeMath for uint256;

  // minimum amount of funds to be raised in weis
  uint256 public goal;
  bool private _goalReached = false;
  // refund vault used to hold funds while crowdsale is running
  RefundVault private vault;

  function RefundableCrowdsale(uint256 _goal) {
    require(_goal > 0);
    vault = new RefundVault(wallet);
    goal = _goal;
  }

  // We're overriding the fund forwarding from Crowdsale.
  // In addition to sending the funds, we want to call
  // the RefundVault deposit function
  function forwardFunds() internal {
    vault.deposit.value(msg.value)(msg.sender);
  }

  // if crowdsale is unsuccessful, investors can claim refunds here
  function claimRefund() public {
    require(isFinalized);
    require(!goalReached());

    vault.refund(msg.sender);
  }

  // vault finalization task, called when owner calls finalize()
  function finalization() internal {
    if (goalReached()) {
      vault.close();
    } else {
      vault.enableRefunds();
    }
    super.finalization();
  }

  function goalReached() public constant returns (bool) {
    if (weiRaised >= goal) {
      _goalReached = true;
      return true;
    } else if (_goalReached) {
      return true;
    } 
    else {
      return false;
    }
  }

  function updateGoalCheck() onlyOwner public {
    _goalReached = true;
  }

  function getVaultAddress() onlyOwner public returns (address) {
    return vault;
  }
}