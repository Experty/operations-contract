pragma solidity ^0.4.4;


contract Operations {

  mapping (address => uint) balances;

  // mapping(address => mapping (address => uint256)) allowed;

  function Operations() {
    
  }

  function deposit() payable {
    balances[msg.sender] = msg.value;
  }

  function withdraw(uint value) payable {
    uint amount = balances[msg.sender];
    
    assert(value <= amount);
    
    balances[msg.sender] -= value;
    msg.sender.transfer(value);
  }

  function startCall() {

  }

  function endCall() {

  }

  function getBalance() returns (uint balance) {
    return balances[msg.sender];
  }

}
