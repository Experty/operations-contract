pragma solidity ^0.4.4;

// kovan:


contract ERC223Token {
  function transfer(address _from, uint _value, bytes _data) public;
}

contract Operations {

  mapping (address => uint) public balances;
  mapping (address => bytes32) public activeCall;

  ERC223Token public exy;

  function Operations() public {
    exy = ERC223Token(0x1cB96a14c8f2dfdb198E3Bd0780f9fd69afD239f);
  }

  // falback for EXY deposits
  function tokenFallback(address _from, uint _value, bytes _data) public {
    balances[_from] += _value;
  }

  function withdraw(uint value) public {
    // dont allow to withdraw any balance if user have active call
    require(activeCall[msg.sender] == 0x0);

    uint balance = balances[msg.sender];

    // throw if balance is lower than requested value
    require(balance < value);

    balances[msg.sender] -= value;
    bytes memory empty;
    exy.transfer(msg.sender, value, empty);
  }

  function startCall(uint timestamp, uint8 _v, bytes32 _r, bytes32 _s) public {
    // address caller == ecrecover(...)
    // address recipient == msg.sender
    bytes32 callHash = keccak256('Experty.io startCall:', msg.sender, timestamp);
    address caller = ecrecover(callHash, _v, _r, _s);

    // caller cant start more than 1 call
    require(activeCall[caller] == 0x0);

    activeCall[caller] = callHash;
  }

  function endCall(bytes32 callHash, uint amount, uint8 _v, bytes32 _r, bytes32 _s) public {
    bytes32 endHash = keccak256('Experty.io endCall:', callHash, amount);
    address caller = ecrecover(endHash, _v, _r, _s);

    // check if call hash was created by caller
    require(activeCall[caller] == callHash);

    uint maxAmount = amount;
    if (maxAmount > balances[caller]) {
      maxAmount = balances[caller];
    }

    settlePayment(caller, msg.sender, maxAmount);

    activeCall[caller] = 0x0;
  }
/*
  // end call can be requested by caller
  // if recipient did not published it
  function endCallRequest() public {

  }*/

  function settlePayment(address sender, address recipient, uint value) private {
    balances[sender] -= value;
    balances[recipient] += value;
  }

}
