pragma solidity ^0.4.4;


contract Operations {

  mapping (address => uint) balances;

  // mapping(address => mapping (address => uint256)) allowed;

  function Operations() {
    
  }

  function deposit() payable {
    balances[msg.sender] = msg.value;
  }

  function withdraw(uint value) {
    uint amount = balances[msg.sender];
    
    if (value < amount) {
      amount = value;
    }
    
    balances[msg.sender] -= amount;
    msg.sender.transfer(amount);
  }

  function startCall() {

  }

  function endCall() {

  }

  function getBalance() returns (uint balance) {
    return balances[msg.sender];
  }

}
