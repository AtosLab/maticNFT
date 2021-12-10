// Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721]'
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

import "hardhat/console.sol";

contract bulkNFT is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    uint constant NUM = 2;
    address[] recipiency;

    constructor() ERC721("maticNFT", "NFT") {
      // hardcoded address for testing
      recipiency.push(0xE0f5206BBD039e7b0592d8918820024e2a7437b9);
      recipiency.push(0x9106BcAFb5cdcbbA5bD0d98fBbf2d82fD4245201);
      // call erc721 _mint
      // _mint emits an event each time
      for (uint i = 0; i < NUM; i++) {
        //comment out if want to do mintManyNFT
        //super._mint(recipiency[i], i);
      }
    }

    function registerAddress(address added) public { 
      recipiency.push(added);  
    }

    //get the current supply of tokens
    function totalSupply() public view returns (uint256) {
        return _tokenIds.current();
    }

    // for opensea collection 
    function contractURI() public pure returns (string memory) {
        return "https://ipfs.io/ipfs/QmcxJNpGFmAfxVwh56ik8v7DFHxRHCm6m1QfZGt3wKsWuW";
    }

    function mintNFT(address recipient, string memory tokenURI)
        public onlyOwner
        returns (uint256)
    {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }

    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }

    function append(string memory a, string memory b, string memory c, string memory d) 
      internal pure returns (string memory) {
        return string(abi.encodePacked(a, b, c, d));
    }

    function mintManyNFT(address[] memory recipients, string memory tokenURI)
        public onlyOwner
        returns (uint256)
    {
        uint256 newItemId;
        string memory newTokenURI;
        string memory integerIndex;
        console.log("length %d", recipients.length);
        for (uint i = 0; i < recipients.length; i++) {
          console.log("recipient %s", recipients[i]);

          _tokenIds.increment();
          newItemId = _tokenIds.current();
          _mint(recipients[i], newItemId);

          integerIndex = uint2str(i);
          newTokenURI = append(tokenURI, '/',integerIndex, '.json');
          console.log(newTokenURI);
          _setTokenURI(newItemId, newTokenURI);
        }

        return recipients.length;
    }

    function updateNFT(uint256 tokenId, string memory tokenURI)
        public onlyOwner
    {
        _setTokenURI(tokenId, tokenURI);
    }
}
