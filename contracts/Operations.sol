pragma solidity ^0.4.4;


contract Operations {

  struct Call {
    uint ratePerS;
    uint timestamp;
    bool isFinished;
  }

  mapping (address => uint) public balances;
  mapping (address => bool) public activeCaller;
  mapping (address => mapping (address => Call)) public calls;

  event Error(string message);

  function Operations() {
  }

  function deposit() payable {
    balances[msg.sender] += msg.value;
  }

  function withdraw(uint value) {

    // dont allow to withdraw any balance if user have active call
    if (activeCaller[msg.sender]) {
      Error('Can`t withdraw funds until call is not finished');
      throw;
    }

    uint balance = balances[msg.sender];

    // throw if balance is lower than requested value
    if (balance < value) {
      Error('Can`t withdraw more than you have in contract');
      throw;
    }

    balances[msg.sender] -= value;
    msg.sender.transfer(value);
  }

  function startCall(address caller, address recipient, uint ratePerS, uint timestamp) {

    // caller can have only 1 active call
    if (activeCaller[caller]) {
      Error('Can`t start another call while actual call');
      throw;
    }

    // only caller can init the call
    if (caller != msg.sender) {
      Error('Only caller can init the call');
      throw;
    }

    activeCaller[caller] = true;

    calls[caller][recipient] = Call({
      ratePerS: ratePerS,
      timestamp: timestamp,
      isFinished: false
    });
  }

  function endCall(address caller, address recipient, uint timestamp) {

    // only caller can init the call
    if (caller != msg.sender && recipient != msg.sender) {
      Error('Only caller or recipient can end call');
      throw;
    }

    Call memory call = calls[caller][recipient];

    // cant finish call twice
    if (call.isFinished) {
      Error('Can`t finish single call more than once');
      throw;
    }

    uint duration = timestamp - call.timestamp;
    uint cost = duration * call.ratePerS;

    uint maxCost = cost;
    if (maxCost > balances[caller]) {
      maxCost = balances[caller];
    }

    activeCaller[caller] = false;

    settlePayment(caller, recipient, maxCost);

    call.isFinished = true;
  }

  function settlePayment(address sender, address recipient, uint value) private {
    balances[sender] -= value;
    balances[recipient] += value;
  }
  
  function getActiveCall(address caller, address recipient) internal returns (Call call) {
    return calls[caller][recipient];
  }

}