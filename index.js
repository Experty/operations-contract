
const abi = require('ethereumjs-abi');
const BN = require('bn.js');;
// const Web3 = require('web3');
const ethUtil = require('ethereumjs-util');
const Account = require('eth-lib/lib/account');

let callerPriv = 'a1df672f9fdb62cecf543e17e23bd1b18b541c0bef8082c6eabc79f5e96732e6';
let callerAddr = '0xDC7D8b3DEBD41730e22180cD621dA6AD8D96B71B';

let recipientAddr = '0x5024E5a48c06d39A40931bdE2c1c6b189D004974';

let startCallTest = function() {
  let timestamp = new BN('1512662823980', 10);
  let callHash = abi.soliditySHA3(
    ['string', 'address', 'uint'],
    ['Experty.io startCall:', recipientAddr, timestamp]
  ).toString('hex');

  let sig = createSignMessage(callerPriv, callHash);

  console.log(callHash, sig);
};

let createSignMessage = (privateKey, messageHash) => {
  privateKey = ethUtil.addHexPrefix(privateKey);

  const signature = Account.sign(messageHash, privateKey);
  const vrs = Account.decodeSignature(signature);

  return {
    messageHash,
    v: vrs[0],
    r: vrs[1],
    s: vrs[2],
    signature
  };
};


startCallTest();
