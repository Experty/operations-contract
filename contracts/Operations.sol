pragma solidity ^0.4.4;


contract Operations {

  struct Call {
    uint ratePerS;
    uint timestamp;
  }

  mapping (address => uint) public balances;
  mapping (address => bool) public activeCaller;
  mapping(address => mapping (address => Call)) public calls;

  function Operations() {
  }

  function deposit() payable {
    balances[msg.sender] += msg.value;
  }

  function withdraw(uint value) payable {

    // dont allow to withdraw any balance if user have active call
    assert(!activeCaller[msg.sender]);

    uint balance = balances[msg.sender];

    // throw if balance is lower than requested value
    assert(value <= balance);

    balances[msg.sender] -= value;
    msg.sender.transfer(value);
  }

  function startCall(address caller, address recipient, uint ratePerS, uint timestamp) {

    // caller can have only 1 active call
    assert(!activeCaller[caller]);

    activeCaller[caller] = true;

    calls[caller][recipient] = Call({
      ratePerS: ratePerS,
      timestamp: timestamp
    });
  }

  function endCall(address caller, address recipient, uint timestamp) {
    Call call = calls[caller][recipient];
    require(timestamp > call.timestamp);

    uint duration = timestamp - call.timestamp;
    uint cost = duration * call.ratePerS;

    uint maxCost = cost;
    if (maxCost > balances[caller]) {
      maxCost = balances[caller];
    }

    settlePayment(caller, recipient, maxCost);
  }

  function settlePayment(address sender, address recipient, uint value) private {
    balances[sender] -= value;
    balances[recipient] += value;
  }
  
  function getActiveCall(address caller, address recipient) internal returns (Call call) {
    return calls[caller][recipient];
  }

}
