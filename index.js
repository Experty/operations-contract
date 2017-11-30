
const sha3 = require('solidity-sha3').default;

const abi = require('ethereumjs-abi');
const BN = require('bn.js');


// // solidity:
// address caller = 0x123;
// bytes32 callHash = 0x124;
// uint amount = 10000000000000000000;
// return sha3('Experty.io Signed Message:', caller, amount);

let hash = abi.soliditySHA3(
  ['string', 'address', 'uint'],
  ['Experty.io Signed Message:', 0x123, new BN('10000000000000000000', 10)]
).toString('hex');

console.log('hash: ', hash);
