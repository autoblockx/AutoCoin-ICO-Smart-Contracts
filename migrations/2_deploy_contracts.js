
var AutoCoinICO = artifacts.require('../contracts/AutoCoinICO.sol');


module.exports = function(deployer) {

    // Crowdsale StartTime
    var _startTime = 1531180800;
    
    // Crowdsale EndTime
    var _endTime = 1547164799; 

    // Token Rate
    var _rate = 2600;

    // HardCap
    var _cap = 40000 * 10**18;

    // SoftCap
    var _goal = 5000 * 10**18;

    // Wallet Address
    var _wallet = "Enter wallet address to get raised investment";

    return deployer.deploy(AutoCoinICO, _startTime, _endTime, _rate, _goal, _cap, _wallet).then( async () => {

        const instance = await AutoCoinICO.deployed(); 
        const token = await instance.getTokenAddress.call();
        const vault =  await instance.getVaultAddress.call();

        console.log('Token Address', token);
        console.log('Vault Address', vault);
        console.log(_startTime)
        console.log(_endTime)

    });

};



