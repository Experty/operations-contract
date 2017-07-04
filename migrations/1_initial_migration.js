var Migrations = artifacts.require("./Migrations.sol");

module.exports = function(deployer, network) {
  if (network === "development") web3.personal.unlockAccount(web3.eth.accounts[0], "");
  deployer.deploy(Migrations);
};
