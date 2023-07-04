// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Access {
    event RoleGranted(
        Role indexed role,
        address indexed account,
        address indexed sender
    );
    event RoleRevoked(address indexed account, address indexed sender);

    enum Role {
        Default,
        Admin,
        Mint
    }

    modifier onlyRole(Role _role) {
        if (_role == Role.Admin) {
            require(
                roles[msg.sender] == _role,
                "Only ADMIN can perform this action"
            );
        } else {
            require(
                roles[msg.sender] == Role.Mint ||
                    roles[msg.sender] == Role.Admin,
                "Only MINTER can perform this action"
            );
        }
        _;
    }

    mapping(address => Role) roles;

    function grantRole(
        address _account,
        Role _role
    ) public onlyRole(Role.Admin) {
        _grantRole(_account, _role);
    }

    function _grantRole(address _account, Role _role) internal {
        if (!hasRole(_account, _role)) {
            roles[_account] = _role;
            emit RoleGranted(_role, _account, msg.sender);
        }
    }

    function revokeRole(address _account) public onlyRole(Role.Admin) {
        _revokeRole(_account);
    }

    function _revokeRole(address _account) internal {
        if (hasRole(_account, Role.Admin) || hasRole(_account, Role.Mint)) {
            delete roles[_account];
            emit RoleRevoked(_account, msg.sender);
        }
    }

    function getRole(address _account) public view returns (Role) {
        return roles[_account];
    }

    function hasRole(address _account, Role _role) public view returns (bool) {
        return roles[_account] == _role;
    }
}
