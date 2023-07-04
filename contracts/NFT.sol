// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MyTestToken is ERC721, AccessControl {
    using Counters for Counters.Counter;
    uint256 public totalSupply;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("MyTestToken", "TKN") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
    }

    function _baseURI() internal pure override returns (string memory) {
        return
            "https://ipfs.io/ipfs/QmUAfW9VqWJnq8RD9ZSmuvVKvCXaFt7VFyr33GHLAk3nwZ/";
    }

    function safeMint() public onlyRole(MINTER_ROLE) {
        require(totalSupply < 3, "Supply has been exhausted!");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
        totalSupply++;
    }

    function grantMintRole(address account) public {
        grantRole(MINTER_ROLE, account);
    }

    function revokeMintRole(address account) public {
        revokeRole(MINTER_ROLE, account);
    }

    // The following functions are overrides required by Solidity.

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
