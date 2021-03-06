pragma solidity ^0.5.0;

/// @title Withdrawal contract interface
interface WithdrawInterface {

    /// @dev Withdraw tokens to address
    function withdraw(address to, uint256 amount) external returns (bool);

    /// @dev Check balance on contract for token address
    function balance() view external returns (uint256);

    /// @dev Check user tokens balance
    function balanceOf(address user) view external returns (uint256);

    /// @dev Batch withdraw to addresses
    function batchWithdraw(address [] calldata to, uint256 [] calldata amounts) external returns (bool);
}
