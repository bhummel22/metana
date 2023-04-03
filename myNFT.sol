// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/utils/Counters.sol";

contract MyNFT is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdTracker;

    struct NFT {
        string name;
        string pictureUrl;
        string trait1;
        string trait2;
    }

    mapping (uint256 => NFT) private _nftData;

    constructor() ERC721("My NFT", "MNFT") {}

    function mintNFT(address to, string memory name, string memory pictureUrl, string memory trait1, string memory trait2) public returns (uint256) {
        _tokenIdTracker.increment();
        uint256 newTokenId = _tokenIdTracker.current();
        _mint(to, newTokenId);
        _nftData[newTokenId] = NFT(name, pictureUrl, trait1, trait2);
        return newTokenId;
    }

    function getNFTData(uint256 tokenId) public view returns (string memory name, string memory pictureUrl, string memory trait1, string memory trait2) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        NFT storage nft = _nftData[tokenId];
        return (nft.name, nft.pictureUrl, nft.trait1, nft.trait2);
    }
}

