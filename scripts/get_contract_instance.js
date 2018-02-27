// Getting an instance of the contract in memory so we can access it's methods
// as defined in the ABI
var creeCoin;
CreeCoin.deployed().then(function(instance) { creeCoin = instance; });
