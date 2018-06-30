module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
};
  

var HDWalletProvider = require("truffle-hdwallet-provider");

var infura_apikey = "Infura API Key";
var mnemonic = "Enter seed words of the account";

module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*" // Match any network id
    },
    rinkeby: {
      provider: new HDWalletProvider(mnemonic, "https://rinkeby.infura.io/"+infura_apikey),
      network_id: 4
    },
    mainnet: {
      provider: new HDWalletProvider(mnemonic, "https://mainnet.infura.io/"+infura_apikey),
      network_id: 1,
      gaslimit: 200000
    },
    solc: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  }
};