pragma solidity ^0.5.0;

import "./WithdrawInterface.sol";
import "./DepositInterface.sol";
import "../EsilliumFlat.sol";

/// @title Withdraw contract
contract FundsManagementContract is WithdrawInterface, DepositInterface, Ownable {

    /// @dev ERC20 base contract
    address public erc20Contract;

    constructor(address _contract) {
        erc20Contract = _contract;
        owner = msg.sender;
    }

    /// Getters and Setters

    /// @dev Update contract
    function setNewContract(address newContract) public onlyOwner {
        erc20Contract = newContract;
    }
}
