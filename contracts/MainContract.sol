pragma solidity ^0.5.0;

import "./libs/FreezableToken.sol";
import "./libs/Pausable.sol";

/**
 * @title Contract constants
 * @dev  Contract whose consisit base constants for contract
 */
contract ContractConstants {

    uint256 internal TOKEN_BUY_PRICE;

    uint256 internal TOKEN_BUY_PRICE_DECIMAL;

    uint256 internal TOKENS_BUY_LIMIT;
}

/**
 * @title MainContract
 * @dev Base contract which using for initializing new contract
 */
contract MainContract is ContractConstants, FreezableToken, Pausable {

    string private _name;

    string private _symbol;

    uint private _decimals;

    uint private _decimalsMultiplier;

    uint256 internal buyPrice;

    uint256 internal buyPriceDecimals;

    uint256 internal buyTokensLimit;

    uint256 internal boughtTokensByCurrentPrice;

    uint256 internal membersCount;

    event Buy(address target, uint256 eth, uint256 tokens);

    event NewLimit(uint256 prevLimit, uint256 newLimit);

    event SetNewPrice(uint256 prevPrice, uint256 newPrice);

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
     * @return return payable function buy limit
     */
    function getBuyTokensLimit() public view returns (uint256) {
        return buyTokensLimit;
    }

    /**
     * @return return count of bought tokens for current price
     */
    function getBoughtTokensByCurrentPrice() public view returns (uint256) {
        return boughtTokensByCurrentPrice;
    }

    /**
     * @dev set prices for sell tokens and buy tokens
     */
    function setPrices(uint256 newBuyPrice) public onlyOwnerOrAdmin {

        emit SetNewPrice(buyPrice, newBuyPrice);

        buyPrice = newBuyPrice;

        boughtTokensByCurrentPrice = 0;
    }

    /**
     * @dev set max buy tokens
     */
    function setLimit(uint256 newLimit) public onlyOwnerOrAdmin {

        emit NewLimit(buyTokensLimit, newLimit);

        buyTokensLimit = newLimit;
    }

    /**
    * @dev set limit and reset price
    */
    function setLimitAndPrice(uint256 newLimit, uint256 newBuyPrice) public onlyOwnerOrAdmin {
        setLimit(newLimit);
        setPrices(newBuyPrice);
    }

    /**
     * @dev set prices for sell tokens and buy tokens
     */
    function setPricesDecimals(uint256 newBuyDecimal) public onlyOwnerOrAdmin {
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
    function init(string memory __name, string memory __symbol, uint __decimals, uint __totalSupply, address __owner, address __admin) public {
        _name = __name;
        _symbol = __symbol;
        _decimals = __decimals;
        _decimalsMultiplier = 10 ** _decimals;
        if (paused) {
            pause();
        }
        setPrices(TOKEN_BUY_PRICE);
        setPricesDecimals(TOKEN_BUY_PRICE_DECIMAL);
        uint256 generateTokens = __totalSupply * _decimalsMultiplier;
        setLimit(TOKENS_BUY_LIMIT);
        if (generateTokens > 0) {
            mint(__owner, generateTokens);
            approve(__owner, balanceOf(__owner));
        }
        addAdmin(__admin);
        transferOwnership(__owner);
    }

    function() external payable {
        buy(msg.sender, msg.value);
    }

    function calculateBuyTokens(uint256 _value) public view returns (uint256) {
        uint256 buyDecimal = 10 ** buyPriceDecimals;
        return (_value * _decimalsMultiplier) / (buyPrice * buyDecimal);
    }

    /**
     * @dev buy tokens 
     */
    function buy(address _sender, uint256 _value) internal {
        require(_value > 0, 'MainContract: Value must be bigger than zero');
        require(buyPrice > 0, 'MainContract: Cannot buy tokens');
        require(boughtTokensByCurrentPrice < buyTokensLimit, 'MainContract: Cannot buy tokens more than current limit');
        uint256 amount = this.calculateBuyTokens(_value);
        if (boughtTokensByCurrentPrice + amount > buyTokensLimit) {
            amount = buyTokensLimit - boughtTokensByCurrentPrice;
        }
        membersCount = membersCount.add(1);
        _transfer(owner, _sender, amount);
        boughtTokensByCurrentPrice = boughtTokensByCurrentPrice.add(amount);
        address(uint160(owner)).transfer(_value);
        emit Buy(_sender, _value, amount);
    }
}
