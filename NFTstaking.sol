// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";

contract MyERC20 is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {}

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}

contract MyERC721 is ERC721, ERC721Holder {
    constructor(string memory name, string memory symbol) ERC721(name, symbol) {}

    function mint(address to, uint256 tokenId) external {
        _safeMint(to, tokenId);
    }
}

contract MyMintingContract {
    MyERC20 public _myToken;
    MyERC721 public _myNFT;

    mapping(uint256 => address) public originalOwner;


    constructor(address myToken, address myNFT) {
        _myToken = MyERC20(myToken);
        _myNFT = MyERC721(myNFT);

    }

    function depositNFT(uint256 tokenId) external {
        originalOwner[tokenId] = msg.sender;
        _myNFT.safeTransferFrom(msg.sender, address(this), tokenId);

    }

    function withdrawNFT(uint256 tokenId) external {
        require(originalOwner[tokenId] == msg.sender, "not original owner");
        _myNFT.safeTransferFrom(address(this), msg.sender, tokenId);


    }
}    