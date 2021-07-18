pragma solidity ^0.5.0;

/// @title Deposit interface contract
interface DepositInterface {

    /// @dev Deposit funds to contract balance
    function deposit() external payable;

    /// @dev Deposit funds from address to system
    function depositFrom(address _from) external payable;
}
