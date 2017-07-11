module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*" // Match any network id
    },
    ec2: {
      host: "ec2-52-28-244-15.eu-central-1.compute.amazonaws.com",
      port: 8545,
      network_id: "*"
    }
  }
};
