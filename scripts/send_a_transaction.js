// Transacting with a getter function that makes some change to the state of
// the contract and needs to store this new state on the blockchain in the
// contract storage.

// Here we have an instance of the CreeCoin contract (creeCoin) and we are
// calling the mint() method which takes two paramaters, a receiver and an
// amount, and then mints those coins (tokens) into the receiving account.
creeCoin.mint("0x0123...", 20).then(result => console.log(result));
// Using then() to capture the promise and log on return means that when the
// transaction has been mined a transaction object will be returned. Let's save
// this transaction object so we can view it's properties.
var tx;
creeCoin.mint("0x0123...", 20).then(result => tx = result));
// Now we can browse properties such as logs, receipt, transaction ID etc.
tx.tx;                      // transaction ID
tx.logs[0].event;           // string name of the event fired
tx.receipt.gasUsed;         // gas used to mine transaction
