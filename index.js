
const abi = require('ethereumjs-abi');
const BN = require('bn.js');;
const Web3 = require('web3');
const ethUtil = require('ethereumjs-util');
const Account = require('eth-lib/lib/account');

let callerPriv = 'a1df672f9fdb62cecf543e17e23bd1b18b541c0bef8082c6eabc79f5e96732e6';
let callerAddr = '0xDC7D8b3DEBD41730e22180cD621dA6AD8D96B71B';

let recipientAddr = '0x5024E5a48c06d39A40931bdE2c1c6b189D004974';

let createSignMessage = (privateKey, messageHash) => {
  let privkey = ethUtil.toBuffer(ethUtil.addHexPrefix(privateKey));
  let hash = ethUtil.toBuffer(ethUtil.addHexPrefix(messageHash));
  let vrs = ethUtil.ecsign(hash, privkey);
  return {
    vrs,
    v: ethUtil.bufferToHex(vrs.v),
    r: ethUtil.bufferToHex(vrs.r),
    s: ethUtil.bufferToHex(vrs.s)
  }
};

let startCallTest = function() {
  let timestamp = new BN('1512662823980', 10);
  let callHash = abi.soliditySHA3(
    ['string', 'address', 'uint'],
    ['Experty.io startCall:', recipientAddr, timestamp]
  ).toString('hex');

  let sig = createSignMessage(callerPriv, callHash);

  console.log('callHash: ', callHash, sig);
  return callHash;
};

let endCallTest = function() {
  let callHash = startCallTest();
  let amount = new BN('123', 10);
  let endHash = abi.soliditySHA3(
    ['string', 'address', 'bytes32', 'uint'],
    ['Experty.io endCall:', recipientAddr, Buffer.from(callHash, 'hex'), amount]
  ).toString('hex');

  let sig = createSignMessage(callerPriv, endHash);

  console.log('endHash: ', endHash, sig);
};

endCallTest();
