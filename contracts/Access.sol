// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Access {
    enum Role {
        Admin,
        Minter
    }

    mapping(address => Role) roles;

    function grantRole(Role _role, address _account) internal {
        roles[_account] = _role;
    }
}
