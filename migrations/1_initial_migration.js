var Migrations = artifacts.require("./Migrations.sol");

module.exports = function(deployer, network) {
  if (network === "development") {
    try {
      // try to unlock account for deploying the contracts
      web3.personal.unlockAccount(web3.eth.accounts[0], "");
    } catch(e) {}
  }
  deployer.deploy(Migrations);
};
