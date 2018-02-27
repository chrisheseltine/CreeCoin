// Calling a view function, such as a public variable (auto-generated getter)
// or a public contract method.

// Here we have an instance of the CreeCoin contract (creeCoin) and we are
// calling the balances property which is a mapping of address to uint256. To
// lookup the correct value of balances we pass the address (the key) as the
// first paramater to call().
creeCoin.balances.call("0x0123...");

// This returns a promise, so best to use then(), also we can convert it from
// a big number to a string representation.
creeCoin.balances.call("0x0123...").then(result => result.toString());

// Calling a method works the same. Here we call the balanceOf() function which
// does the same thing as above, and prints the same results.
creeCoin.balanceOf.call("0x0123...").then(result => result.toString());
