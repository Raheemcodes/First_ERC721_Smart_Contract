// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./Access.sol";

contract CustomRole is ERC721, Access {
    using Counters for Counters.Counter;
    uint256 public totalSupply;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("MyTestToken", "TKN") {
        grantRole(Role.Admin, msg.sender);
        grantRole(Role.Mint, msg.sender);
    }

    function _baseURI() internal pure override returns (string memory) {
        return
            "https://ipfs.io/ipfs/QmUAfW9VqWJnq8RD9ZSmuvVKvCXaFt7VFyr33GHLAk3nwZ/";
    }

    function safeMint() public onlyRole(Role.Mint) {
        require(totalSupply < 3, "Supply has been exhausted!");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
        totalSupply++;
    }

    function grantMintRole(address account) public {
        grantRole(Role.Mint, account);
    }

    function revokeMintRole(address account) public {
        revokeRole(account);
    }

    // The following functions are overrides required by Solidity.

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
