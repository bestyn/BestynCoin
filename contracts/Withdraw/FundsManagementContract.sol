pragma solidity ^0.5.0;

import "./WithdrawInterface.sol";
import "./DepositInterface.sol";
import "../libs/SafeMath.sol";
import "../libs/Ownable.sol";


/// @title Withdraw contract
contract FundsManagementContract is WithdrawInterface, DepositInterface, Ownable {
    
    using SafeMath for uint256;

    /// @dev ERC20 base contract
    address public erc20Contract;

    uint256 public limit; // ???
    address payable public depositFunds; 

    constructor(address _contract) public {
        erc20Contract = _contract;
        owner = msg.sender;
        limit = 1000; // limit of 1000 token per withdrawal
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

        (bool success, bytes memory result) = erc20Contract.delegatecall(
            abi.encodeWithSignature("transferFrom(address,address,uint256)", msg.sender, to, amount)
        );

        emit Withdraw(msg.sender, to, amount, success);
        return abi.decode(result, (bool));
    }

    /// @dev Check balance on contract for token address
    function balance(address tokenAddress) external returns (uint256) {
        (bool success, bytes memory result) = tokenAddress.delegatecall(
            abi.encodeWithSignature("balanceOf(address)", msg.sender)
        );

        return abi.decode(result, (uint256));
    }

    /// @dev Batch withdraw to addresses
    function batchWithdraw(address [] calldata to, uint256 amounts) external returns (bool) {
        require(to.length > 0);
        require(amounts <= limit, 'you cannot withdraw so much money at a time');

        uint256 amount = amounts/to.length;

        for(uint32 i = 0; i < to.length; i++) {
            (bool success, bytes memory res) = erc20Contract.delegatecall(
                abi.encodeWithSignature("transferFrom(address,address,uint256)", msg.sender, to[i], amount)
            );
        }

        emit BatchWithdraw(msg.sender, to, amounts, true);
        return true;
    }

    function() external payable {
        emit ValueReceived(msg.sender, msg.value);
    }

    /// @dev Deposit funds to contract balance
    function deposit() external payable {
        uint256 value = msg.value;
        address receiver = msg.sender;

        require(value > 0); 
        require(receiver != address(0)); 
        depositFunds.transfer(msg.value);

        uint256 currencyEsilliumPrice = 1 * (10 * 16); // 0.01 bnb 
        uint256 tokensCount = value.mul(1 ether) / currencyEsilliumPrice;

        erc20Contract.delegatecall(
            abi.encodeWithSignature("transfer(address,uint256)", receiver, tokensCount)
        );
    }

    /// @dev Deposit funds from address to system
    function depositFrom(address _from) external payable {
        uint256 value = msg.value;
        address receiver = msg.sender;

        require(value > 0);
        require(receiver != address(0));
        depositFunds.transfer(msg.value);

        uint256 currencyEsilliumPrice = 1 * (10 * 16); // 0.01 bnb 
        uint256 tokensCount = value.mul(1 ether) / currencyEsilliumPrice;

        erc20Contract.delegatecall(
            abi.encodeWithSignature("transferFrom(address,address,uint256)", _from, receiver, tokensCount)
        );
    }

}