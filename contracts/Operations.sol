pragma solidity ^0.4.4;


contract Operations {

  mapping (address => uint) balances;

  struct Call {
    uint ratePerS;
    uint timestamp;
  }

  mapping(address => mapping (address => Call)) calls;
  mapping (address => bool) activeCallers;

  function Operations() {

  }

  function deposit() payable {
    balances[msg.sender] += msg.value;
  }

  function withdraw(uint value) payable {
    uint amount = balances[msg.sender];

    assert(value <= amount);

    balances[msg.sender] -= value;
    msg.sender.transfer(value);
  }

  function startCall(address caller, address recipient, uint ratePerS, uint timestamp) {
    assert(!activeCallers[caller]); // make sure that the caller doesn't call 2 people at the same time
    activeCallers[caller] = true;
    calls[caller][recipient] = Call({
      ratePerS: ratePerS,
      timestamp: timestamp
    });
  }

  function endCall(address caller, address recipient, uint timestamp) {
    uint duration = timestamp - calls[caller][recipient].timestamp;
  }

  function getBalance() returns (uint balance) {
    return balances[msg.sender];
  }

}
