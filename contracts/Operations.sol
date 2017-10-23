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
  }

  mapping (address => uint) public balances;
  mapping (address => bool) public activeCaller;
  mapping (address => mapping (address => Call)) public calls;

  ERC223Token public exy;

  function Operations() public {
    exy = ERC223Token(0x1cB96a14c8f2dfdb198E3Bd0780f9fd69afD239f);
  }

  // function deposit() payable {
  //   balances[msg.sender] += msg.value;
  // }

  // falback for EXY deposits
//   function tokenFallback(address _from, uint _value, bytes _data) public {
//     balances[_from] += _value;
//   };

  function withdraw(uint value) public {

    // dont allow to withdraw any balance if user have active call
    assert(!activeCaller[msg.sender]);

    uint balance = balances[msg.sender];

    // throw if balance is lower than requested value
    assert(value <= balance);

    balances[msg.sender] -= value;
    bytes memory empty;
    exy.transfer(msg.sender, value, empty);
  }

  function startCall(address caller, address recipient, uint ratePerS, uint timestamp) public {

    // caller can have only 1 active call
    assert(!activeCaller[caller]);

    activeCaller[caller] = true;

    calls[caller][recipient] = Call({
      ratePerS: ratePerS,
      timestamp: timestamp
    });
  }

  function endCall(address caller, address recipient, uint timestamp) public {
    Call memory call = calls[caller][recipient];
    require(timestamp > call.timestamp);

    uint duration = timestamp - call.timestamp;
    uint cost = duration * call.ratePerS;

    uint maxCost = cost;
    if (maxCost > balances[caller]) {
      maxCost = balances[caller];
    }

    activeCaller[caller] = false;

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
