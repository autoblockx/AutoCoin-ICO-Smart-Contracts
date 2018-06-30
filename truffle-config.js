  

var HDWalletProvider = require("truffle-hdwallet-provider");

var infura_apikey = "Lc2vdbhIswp6iQDRcmSa";
var mnemonic = "raven awesome chair teach life cool bus dose useless infant develop enough";

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
    }
  }
};