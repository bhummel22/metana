// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./myToken.sol";
import "./myNFT.sol";

contract MyMintingContract {
    MyToken private _token;
    MyNFT private _nft;

    constructor(address tokenAddress, address nftAddress) {
        _token = MyToken(tokenAddress);
        _nft = MyNFT(nftAddress);
    }

    function mintNFT(string memory name, string memory pictureUrl, string memory trait1, string memory trait2) public {
        require(_token.allowance(msg.sender, address(this)) >= 10 * 10 ** _token.decimals(), "Must approve transfer of 10 tokens to mint NFT");
        require(_token.transferFrom(msg.sender, address(this), 10 * 10 ** _token.decimals()), "Token transfer failed");
        _nft.mintNFT(msg.sender, name, pictureUrl, trait1, trait2);
    }
}

