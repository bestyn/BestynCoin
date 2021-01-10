pragma solidity ^0.5.0;

import "@openzeppelin/contracts-ethereum-package/contracts/access/Roles.sol";
import "./Ownable.sol";

contract AccessControl is Ownable{

    using Roles for Roles.Role;

    //Contract admins
    Roles.Role internal _admins;

    // Events
    event AddedAdmin(address _address);
    event DeletedAdmin(address _addess);

    function addAdmin(address newAdmin) public onlyOwner {
        require(newAdmin != address(0), "AccessControl: Invalid new admin address");
        _admins.add(newAdmin);
        emit AddedAdmin(newAdmin);
    }

    function deletedAdmin(address deleteAdmin) public onlyOwner {
        require(deleteAdmin != address(0), "AccessControl: Invalid new admin address");
        _admins.remove(deleteAdmin);
        emit DeletedAdmin(deleteAdmin);
    }
}
