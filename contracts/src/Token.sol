// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol";

contract Token is ERC721URIStorage, Ownable {
    using ECDSA for bytes32;
    
    mapping(address => uint256) public nonces;
    mapping(address => bool) public whitelist;
    
    event TokenMinted(address indexed owner, uint256 indexed tokenId);
    
    // Mapping to store the token URI for each token ID
    mapping(uint256 => string) private _tokenURIs;

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {}

    function whitelistGroup(address[] memory _addresses) public onlyOwner {
        for (uint256 i = 0; i < _addresses.length; i++) {
            whitelist[_addresses[i]] = true;
        }
        
    }
    
    function metaMint(uint256 _tokenId, address _owner, uint256 _nonce, bytes memory _signature, string memory _tokenURI) external {
        require(_nonce == nonces[_owner] + 1, "Invalid nonce");
        
        bytes32 messageHash = keccak256(abi.encodePacked(_owner, _nonce, _tokenURI, address(this)));
        address signer = messageHash.recover(_signature);
        require(signer == owner(), "Invalid signature");
        require(whitelist[_owner], "Not whitelisted");
         
        nonces[_owner] = _nonce;
        
        _safeMint(_owner, _tokenId);
        
        // Set the token URI for the minted token
        _setTokenURI(_tokenId, _tokenURI);
        
        emit TokenMinted(_owner, _tokenId);
    }
    
}