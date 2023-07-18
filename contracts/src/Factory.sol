// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Token.sol";

contract MetaMintableTokenFactory {
    address[] public deployedTokens;

    function createToken(string memory _name, string memory _symbol) public {
       Token newToken = new Token(_name, _symbol);
        deployedTokens.push(address(newToken));
    }

    function getDeployedTokens() public view returns (address[] memory) {
        return deployedTokens;
    }
}
