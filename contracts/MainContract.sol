pragma solidity ^0.5.0;

import "@openzeppelin/upgrades/contracts/Initializable.sol";
import "./libs/FreezableToken.sol";
import "./libs/Pausable.sol";

/** 
 * @title Contract constants 
 * @dev  Contract whose consisit base constants for contract 
 */
contract ContractConstants{
  uint256 internal TOKEN_BUY_PRICE = 200;
  
  uint256 internal TOKEN_BUY_PRICE_DECIMAL = 5;
}

/**
 * @title MainContract
 * @dev Base contract which using for initializing new contract
 */
contract MainContract is ContractConstants, FreezableToken, Pausable, Initializable {

    string private _name;

    string private _symbol;

    uint private _decimals;

    uint private _decimalsMultiplier;

    uint256 internal buyPrice;

    uint256 internal buyPriceDecimals;

    uint256 internal membersCount;

    event Buy(address target, uint256 eth, uint256 tokens);

    constructor (string memory name, string memory symbol, uint decimals, uint totalSupply, address owner) public {
        init(name, symbol, decimals, totalSupply, owner);
    }

    /**
     * @return get token name
     */
    function name() public view returns (string memory) {
        return _name;
    }

    /**
     * @return get token symbol
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    /**
     * @return get token decimals
     */
    function decimals() public view returns (uint) {
        return _decimals;
    }

    /**
     * @return return buy price
     */
    function getBuyPrice() public view returns (uint256) {
        return buyPrice;
    }

    /**
     * @return return buy price decimals
     */
    function getBuyPriceDecimals() public view returns (uint256) {
        return buyPriceDecimals;
    }

     /**
     * @return return count mebers
     */
    function getMembersCount() public view returns (uint256) {
        return membersCount;
    }

    /**
     * @dev set prices for sell tokens and buy tokens
     */
    function setPrices(uint256 newBuyPrice) public onlyOwner{
        buyPrice = newBuyPrice;
    }

    /**
     * @dev set prices for sell tokens and buy tokens
     */
    function setPricesDecimals(uint256 newBuyDecimal) public onlyOwner{
        buyPriceDecimals = newBuyDecimal;
    }

    /**
     * @dev override base method transferFrom
     */
    function transferFrom(address _from, address _to, uint256 value) public whenNotPaused returns (bool _success) {
        return super.transferFrom(_from, _to, value);
    }

    /**
     * @dev Override base method transfer
     */
    function transfer(address _to, uint256 value) public whenNotPaused returns (bool _success) {
        return super.transfer(_to, value);
    }

    /**
     * @dev Override base method increaseAllowance
     */
    function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
        return super.increaseAllowance(spender, addedValue);
    }

    /**
    * @dev Override base method decreaseAllowance
    */
    function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
        return super.decreaseAllowance(spender, subtractedValue);
    }

    /**
    * @dev Override base method approve
    */
    function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
        return super.approve(spender, value);
    }

    /**
    * @dev Burn user tokens
    */
    function burn(uint256 _value) public whenNotPaused {
        _burn(msg.sender, _value);
    }

    /**
    * @dev Burn users tokens with allowance
    */
    function burnFrom(address account, uint256 _value) public whenNotPaused {
        _burnFrom(account, _value);
    }

    /**
    *  @dev Mint tokens by owner
    */
    function addTokens(uint256 _amount) public hasMintPermission canMint {
        _mint(msg.sender, _amount);
        emit Mint(msg.sender, _amount);
    }

    /**
    * @dev Function whose calling on initialize contract
    */
    function init(string memory __name, string memory __symbol, uint __decimals, uint __totalSupply, address __owner) public initializer {
        _name = __name;
        _symbol = __symbol;
        _decimals = __decimals;
        _decimalsMultiplier = 10 ** _decimals;
        if (paused) {
            pause();
        }
        setPrices(TOKEN_BUY_PRICE);
        setPricesDecimals(TOKEN_BUY_PRICE_DECIMAL);
        mint(__owner, __totalSupply * _decimalsMultiplier);
        approve(__owner, balanceOf(__owner));
        finishMinting();
        transferOwnership(__owner);
    }

    function() external payable {
        buy(msg.sender, msg.value);
    }

    /**
     * @dev buy tokens 
     */
    function buy(address _sender, uint256 _value) internal{
        require (_value > 0 );
        require (buyPrice > 0);
        uint256 dec = 10 ** buyPriceDecimals; 
        uint256 amount = (_value / buyPrice) * dec; 
        membersCount  = membersCount.add(1);
        _transfer( owner,  _sender, amount);
        emit Buy(_sender, _value, amount);
    }
}
