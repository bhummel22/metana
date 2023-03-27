// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

contract Godmode {
    string public name = "Godmode Token";
    address public owner;
    mapping(address => uint256) balances;
    uint256 public totalSupply;
    event Transfer(address indexed from, address indexed to, uint256 value);
    



    constructor() {
        owner = msg.sender;
    }

    function mintTokensToAddress(address recipient, uint256 amount) public {
        require(msg.sender == owner, "Only contract owner can mint tokens");
        balances[recipient] += amount;
        totalSupply += amount;
        emit Transfer(address(0), recipient, amount);
    }

    function changeBalanceAtAddress(address target, uint256 newBalance) public {
        require(msg.sender == owner, "Only contract owner can modify balances");
        uint256 currentBalance = balances[target]; // Use balances mapping instead of `token`
        if (newBalance > currentBalance) {
            uint256 amountToAdd = newBalance - currentBalance;
            balances[target] += amountToAdd; // Update balances mapping
            totalSupply += amountToAdd;
            emit Transfer(address(0), target, amountToAdd);
        } else if (newBalance < currentBalance) {
            uint256 amountToRemove = currentBalance - newBalance;
            // Do not allow the contract owner's balance to be reduced to zero
            require(target != owner || currentBalance - amountToRemove > 0, "Insufficient balance");
            balances[target] -= amountToRemove; // Update balances mapping
            totalSupply -= amountToRemove;
            emit Transfer(target, address(0), amountToRemove);
        }
    }

    function authoritativeTransferFrom(address from, address to, uint256 amount) public {
        require(msg.sender == owner, "Only owner can authorize transfers");
        require(from != address(0), "Transfer from the zero address");
        require(to != address(0), "Transfer to the zero address");
        require(amount <= balances[from], "Insufficient balance");
        balances[from] -= amount; // Update balances mapping
        balances[to] += amount; // Update balances mapping
        emit Transfer(from, to, amount);
    }
}
