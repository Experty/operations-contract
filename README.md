
### Development

Install parity https://parity.io/parity.html

Run parity testnet

```
parity --geth --chain dev --force-ui --reseal-min-period 0 --jsonrpc-cors http://localhost
```

Run tests

1. Run testrpc: `testrpc`

2. Run test suite(in another tab/terminal): `truffle test`
