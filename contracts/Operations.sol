pragma solidity ^0.4.4;

// kovan: 


 /*
 * Contract that is working with ERC223 tokens
 */
contract ERC223Token {
  function tokenFallback(address _from, uint _value, bytes _data) public;
  function transfer(address _from, uint _value, bytes _data) public;
}

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

  ERC223Token public exy;

  function Operations() public {
    exy = ERC223Token(0x1cB96a14c8f2dfdb198E3Bd0780f9fd69afD239f);
  }

  // function deposit() payable {
  //   balances[msg.sender] += msg.value;
  // }

  // falback for EXY deposits
  function tokenFallback(address _from, uint _value, bytes _data) public {
    balances[_from] += _value;
  };

  function withdraw(uint value) public {
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
    bytes memory empty;
    exy.transfer(msg.sender, value, empty);
  }

  function startCall(address caller, address recipient, uint ratePerS, uint timestamp) public {

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

  function endCall(address caller, address recipient, uint timestamp) public {

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
    calls[caller][recipient].isFinished = true;

    settlePayment(caller, recipient, maxCost);
  }

  function transfer(address addr, uint256 value) public {
    // dont allow to transfer any balance if user have active call
    assert(!activeCaller[msg.sender]);

    uint balance = balances[msg.sender];

    // throw if balance is lower than requested value
    assert(value <= balance);

    balances[msg.sender] -= value;
    bytes memory empty;
    exy.transfer(addr, value, empty);
  }

  function settlePayment(address sender, address recipient, uint value) private {
    balances[sender] -= value;
    balances[recipient] += value;
  }

  function getActiveCall(address caller, address recipient) public view returns (Call call) {
    return calls[caller][recipient];
  }

}
