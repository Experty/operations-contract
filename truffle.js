module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*" // Match any network id
    },
    live: {
      host: "localhost",
      port: 8545,
      network_id: 1
    },
    bcn: {
      host: "ec2-52-29-139-157.eu-central-1.compute.amazonaws.com",
      port: 8545,
      network_id: 1
    }
  }
};
