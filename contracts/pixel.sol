//Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract Colors {
    mapping (uint256 => string)  colors;
    mapping (uint256 => string)  links;
}

contract PixelNFT is ERC721URIStorage, Ownable, Colors {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;

    uint public totalColors;
    uint public maxAmountOfPixel = 10*10;

    constructor() public ERC721("PixelNFT", "PIX") {}

    event colorChanged(string newColor, uint256 tokenId);
    event linkChanged(string newLink, uint256 tokenId);


    function mintNFT(address recipient, string memory tokenURI)
        public returns (uint256)
    {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI);
        totalColors++;

        return newItemId;
    }

    function changeColor(string memory newColor, uint256 tokenId) public {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721: caller is not owner nor approved"
        );
        colors[tokenId] = newColor;
        emit colorChanged(newColor, tokenId);
    }

    function changeColorPack(string[] memory newStats, uint256[] memory tokenIds) public {
        require(newStats.length == tokenIds.length, "Error: list must be the same size");
        for (uint16 id = 0; id < tokenIds.length; id++) {
            require(
            _isApprovedOrOwner(_msgSender(), tokenIds[id]),
            "ERC721: caller is not owner nor approved");
            changeColor(newStats[id], tokenIds[id]);
        }
    }

    function getColor(uint256 tokenId) public view returns (string memory) {
        return colors[tokenId];
    }

    function getAllColors() public view returns (string[] memory) {
        string[] memory result = new string[](totalColors);
        for (uint id = 0; id < totalColors; id++) {
            result[id] = getColor(id);
        }
        return result;
    }

    function changeLink(string memory newLink, uint256 tokenId) public {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721: caller is not owner nor approved"
        );
        links[tokenId] = newLink;
        emit linkChanged(newLink, tokenId);
    }

    function getLink(uint256 tokenId) public view returns (string memory) {
        return links[tokenId];
    }

    function getAllLinks() public view returns (string[] memory) {
        string[] memory result = new string[](totalColors);
        for (uint id = 0; id < totalColors; id++) {
            result[id] = getLink(id);
        }
        return result;
    }
}

