// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract MyToken is ERC20 {
    using SafeMath for uint256;

    address payable public owner;
    uint256 public constant maxSupply = 1_000_000 * 10 ** 18;
    uint256 public contractBalance = 0;
    uint256 public tokensSold = 0;

    constructor() ERC20("My Token", "MTK") {
        owner = payable(msg.sender);
    }

    function mint() public payable {
        require(totalSupply() < maxSupply, "Max supply reached");
        require(msg.value == 1 ether, "Wrong amount of ether sent");
        uint256 amount = 1000 * 10 ** decimals();
        _mint(msg.sender, amount);
    }

    function sellBack(uint256 amount) public {
        require(amount > 0, "Amount must be greater than zero");
        uint256 rate = 500 * 10**15;
        uint256 etherAmount = amount.div(1000).mul(rate);
        require(contractBalance >= etherAmount, "Not enough ether in contract");
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");

        contractBalance = contractBalance.sub(etherAmount);
        tokensSold = tokensSold.add(amount);
        _burn(msg.sender, amount);
        payable(msg.sender).transfer(etherAmount);
    }

    function withdraw() public {
        require(msg.sender == owner, "Not authorized");
        owner.transfer(address(this).balance);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
        require(totalSupply().add(tokensSold).add(amount) <= maxSupply, "Max supply reached");
        if (to == address(this)) {
            uint256 rate = 500 * 10**15;
            uint256 etherAmount = amount.div(1000).mul(rate);
            require(address(this).balance >= etherAmount, "Not enough ether in contract");
            contractBalance = contractBalance.add(etherAmount);
        }
    }
}
