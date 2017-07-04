
### Development

Install parity https://parity.io/parity.html

Run parity testnet

```
parity --geth --chain dev --force-ui --reseal-min-period 0 --jsonrpc-cors http://localhost
```

Run tests

Note: the tests are using the 'async/await' syntax supported from node v7.6 and will fail to run on older versions

1. Run testrpc: `testrpc`

2. Run test suite(in another tab/terminal): `truffle test`
