# Consultations Network

## Installation
1. Install Parity https://parity.io/parity.html
2. Run `npm install` to set up dependencies

## Development
1. Run parity testnet `parity --geth --chain dev --force-ui --reseal-min-period 0 --jsonrpc-cors http://localhost`
2. Run gulp watcher `npm start`

## Testing
*Note: the tests are using the 'async/await' syntax supported from node v7.6 and will fail to run on older versions*

Just run `npm  test`, test are also automatically executed on file changes
