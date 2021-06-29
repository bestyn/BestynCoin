pragma solidity ^0.5.0;

import "./WithdrawInterface.sol";
import "./DepositInterface.sol";
import "../libs/Ownable.sol";
import "../ERC/IERC20.sol";


/// @title Withdraw contract
contract FundsManagementContract is WithdrawInterface, DepositInterface, Ownable {

    address payable public depositFunds;
    uint256 public limit;

    /// @dev ERC20 base contract
    address public erc20Contract;

    /// @dev ERC20 base contract
    address public tokensOwner;

    constructor(address _contract) public {
        erc20Contract = _contract;
        // 0x184fc447d59a3904c88935615af5A6e550EabfDb
        owner = msg.sender;
        tokensOwner = msg.sender;
        limit = 1000;
        // limit of 1000 token per withdrawal
    }

    /// Getters and Setters

    /// @dev Update contract
    function setNewContract(address newContract) public onlyOwner {
        erc20Contract = newContract;
    }

    function setNewLimit(uint256 newLimit) public onlyOwner {
        limit = newLimit;
    }

    /// Events

    event Withdraw(address from, address to, uint256 amount, bool success);
    event BatchWithdraw(address from, address [] to, uint256 amounts, bool success);
    event ValueReceived(address user, uint amount);

    /// Functions

    function withdraw(address to, uint256 amount) external returns (bool) {
        require(amount <= limit, 'you cannot withdraw so much money at a time');

        bool success = IERC20(erc20Contract).transferFrom(tokensOwner, to, amount);

        emit Withdraw(msg.sender, to, amount, success);
        return success;
    }

    /// @dev Check balance on contract for token address
    function balance() view external returns (uint256) {
        return IERC20(erc20Contract).allowance(tokensOwner, address(this));
    }

    function balanceOf(address user) view external returns (uint256) {
        return IERC20(erc20Contract).balanceOf(user);
    }

    /// @dev Batch withdraw to addresses
    function batchWithdraw(address [] calldata to, uint256 [] calldata amounts) external returns (bool) {
        require(to.length > 0);
        require(to.length == amounts.length, 'invalid data');

        uint256 fullAmounts = 0;
        for (uint32 i = 0; i < amounts.length; i++) {
            fullAmounts += amounts[i];
        }
        require(fullAmounts <= limit, 'you cannot withdraw so much money at a time');

        for (uint32 i = 0; i < to.length; i++) {
            IERC20(erc20Contract).transferFrom(tokensOwner, to[i], amounts[i]);
        }

        emit BatchWithdraw(msg.sender, to, fullAmounts, true);
        return true;
    }

    /// @dev Disable receiving funds to contract address
    function() external payable {
        revert();
    }

    /// @dev Deposit funds to contract balance
    function deposit() external payable {
        uint256 value = msg.value;
        address receiver = msg.sender;

        require(value > 0);
        require(receiver != address(0));
        uint256 currencyEsilliumPrice = 10000000000000;
        // 0.00001 bnb
        uint256 tokensCount = value / currencyEsilliumPrice;

        address tokenOwner = Ownable(erc20Contract).owner();
        IERC20(erc20Contract).transferFrom(tokenOwner, receiver, tokensCount);
        address(uint160(owner)).transfer(msg.value);
    }

    /// @dev Deposit funds from address to system
    function depositFrom(address _from) external payable {
        uint256 value = msg.value;
        address receiver = msg.sender;

        require(value > 0);
        require(receiver != address(0));
        address(uint160(owner)).transfer(msg.value);

        uint256 currencyEsilliumPrice = 10000000000000;
        // 0.00001 bnb
        uint256 tokensCount = value / currencyEsilliumPrice;

        erc20Contract.delegatecall(
            abi.encodeWithSignature("transferFrom(address,address,uint256)", _from, receiver, tokensCount)
        );
    }

}