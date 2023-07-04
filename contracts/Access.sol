// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Access {
    enum Role {
        Admin,
        Minter
    }

    modifier onlyRole(Role _role) {
        if (_role == Role.Admin) {
            require(
                roles[msg.sender] == _role,
                "Only ADMIN can perform this action"
            );
        } else {
            require(
                roles[msg.sender] == _role,
                "Only MINTER can perform this action"
            );
        }
        _;
    }

    mapping(address => Role) roles;

    function grantRole(
        Role _role,
        address _account
    ) internal onlyRole(Role.Admin) {
        roles[_account] = _role;
    }

    function revokeRole(address _account) internal onlyRole(Role.Admin) {
        delete roles[_account];
    }

    function getRole(address _account) public view returns (Role) {
        return roles[_account];
    }

    function hasRole(address _account, Role _role) public view returns (bool) {
        return roles[_account] == _role;
    }
}
