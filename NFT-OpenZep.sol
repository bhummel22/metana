// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract OpenZeppelinNFT is ERC721, Ownable {

    uint256 public tokenSupply = 0;
    uint256 public constant MAX_SUPPLY = 5;
    uint256 public constant PRICE = 0 ether;


    constructor() ERC721("OZNFT", "OZ") {

    }

    function mint() external payable {
        require(tokenSupply < MAX_SUPPLY, "none left");
        require(msg.value == PRICE, "wrong price");

        _mint(msg.sender, tokenSupply);
        tokenSupply++;

    }

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://QmcHetiA8KJm87gGJH5FRN6cwj7oLNB3unfua6hAcyU3mG/";

    }

    function withdraw() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
         
    }


}


