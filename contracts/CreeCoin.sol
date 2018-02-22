pragma solidity ^0.4.2;

import "./eip20/EIP20.sol";

/*
* CreeCoin: A fixed supply coin providing the power of Cree, to all.
*/
contract CreeCoin is EIP20 {
    // Meta for Human Standard Token Compliance
    string public constant name = "CreeCoin";
    string public constant symbol = "CRC";
    uint8 public constant decimals = 2;
    string public constant version = "0.1";

    // Coin supply and pricing
    uint8 public constant initialSupply = 255;
    uint256 public constant tokenPriceInWei = 500000000000000000; // 0.5 ether

    // State
    address public owner;
    address public minter;
    address public distributor;

    uint public totalSupply;

    // Reference values
    address constant private CREATION_ADDRESS = 0x0;

    // Events
    event Minted(address _receiver, uint _amount, uint _newTotalSupply);
    event Transfered(address _from, address _to, uint _amount);
    event Bought(address _buyer, uint _amount);

    /*
    * Initialise the contract and set the contract's initial state.
    */
    function CreeCoin() public {
        // setup owner, minter and distributor roles
        owner = msg.sender;
        minter = owner;
        distributor = owner;

        // distribute and register the initial supply
        balances[distributor] = initialSupply;
        totalSupply = initialSupply;
    }

    /*
    * Mint new coins into the total supply.
    */
    function mint(address _receiver, uint _amount) public {
        // check caller is minter
        require(msg.sender == minter);

        // mint to receiver address
        balances[_receiver] += _amount;
        totalSupply += _amount;

        Minted(_receiver, _amount, totalSupply);
    }

    /*
    * Transfer the role of ownership of the mint
    */
     function setMinter(address _newMinter) public {
        // check caller is minter or owner
        require( ((msg.sender == minter) || (msg.sender == owner)) );

        // set new minter
        minter = _newMinter;
    }

    /*
    * Allows a user to buy tokens for Ether.
    */
    function buy() public payable {
        // check that the amount of ether sent is greater than 0
        require(msg.value > 0);
        // check the amount sent is enough for at least one token
        require(msg.value >= tokenPriceInWei);

        // NOTE: balance is automatically updated by the payable modifier

        // calculate tokens to be distributed as integer
        uint numToDistribute = msg.value / tokenPriceInWei;
        // calculate remainder to be refunded, e.g. 7.1eth sent, 1.1eth to be refunded
        uint refundableRemainderInWei = msg.value - (toWei(numToDistribute));

        // distribute token to sender
        distribute(msg.sender, numToDistribute);
        // refund the remainder
        msg.sender.transfer(refundableRemainderInWei);

        Bought(msg.sender, numToDistribute);
    }

    /*
    * Distribute tokens from distributor to a receiver.
    */
    function distribute(address _receiver, uint _amount) private {
        // check for at least one token, if not something went wrong
        require(_amount > 0);
        // check for balance overflow, causing incorrect balances value
        require(balances[_receiver] + _amount > balances[_receiver]);

        // decrement from distributor and increment receiver
        balances[distributor] -= _amount;
        balances[_receiver] += _amount;
    }

    /*
    * Utility function for converting ether to wei.
    */
    function toWei(uint _amountInEther) private pure returns(uint) {
        return _amountInEther * 1 ether;
    }
}
