//Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract Colors {
    mapping (uint256 => string[100])  colors;
    mapping (uint256 => string)  links;
}

contract PixelNFT is ERC721Enumerable, Ownable, Colors {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;

    uint public totalColors;
    uint public pricePerMint = 0;
    uint public parcelSize = 10*10;
    uint public maxAmountOfPixel = (1000*1000)/(10*10);

    constructor() public ERC721("PixelNFT", "PIX") {}

    event colorChanged(string newColor, uint256 tokenId);
    event linkChanged(string newLink, uint256 tokenId);


    function mintNFT(address recipient)
    public returns (uint256)
    {
        uint256 newItemId = _tokenIds.current();
        _mint(recipient, newItemId);
        _tokenIds.increment();
        return newItemId;
    }

    function withdraw(address payable recipient) public onlyOwner {
        uint256 balance = address(this).balance;
        recipient.transfer(balance);
    }

    function tokensOfOwnerBySize(
        address user
    ) public view returns (uint256[] memory) {
        uint256 length = balanceOf(user);

        uint256[] memory values = new uint256[](length);
        for (uint256 i = 0; i < length; i++) {
            values[i] = tokenOfOwnerByIndex(user, i);
        }
        return (values);
    }

    function changeColorPack(string[10*10] memory newStats, uint256 tokenId) public {
        require(newStats.length == parcelSize, "Error: Colors size must be exact size of the parcel (10*10)");
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721: caller is not owner nor approved");
        colors[tokenId] = newStats;
    }

    function getColor(uint256 tokenId) public view returns (string[10*10] memory) {
        return colors[tokenId];
    }

    function getAllColors() public view returns (string[100][] memory) {
        string[100][] memory result;
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

