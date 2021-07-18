pragma solidity ^0.5.0;

import "./ERC/ERC20.sol";

/**
 * @title MainContract
 * @dev Base contract which using for initializing new contract
 */
contract MainContract is ERC20 {

    string private _name;

    string private _symbol;

    uint private _decimals;

    uint private _decimalsMultiplier;

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
     * @dev override base method transferFrom
     */
    function transferFrom(address _from, address _to, uint256 value) public returns (bool _success) {
        return super.transferFrom(_from, _to, value);
    }

    /**
     * @dev Override base method transfer
     */
    function transfer(address _to, uint256 value) public returns (bool _success) {
        return super.transfer(_to, value);
    }

    /**
     * @dev Override base method increaseAllowance
     */
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        return super.increaseAllowance(spender, addedValue);
    }

    /**
    * @dev Override base method decreaseAllowance
    */
    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        return super.decreaseAllowance(spender, subtractedValue);
    }

    /**
    * @dev Override base method approve
    */
    function approve(address spender, uint256 value) public returns (bool) {
        return super.approve(spender, value);
    }

    /**
    * @dev Function whose calling on initialize contract
    */
    function init(string memory __name, string memory __symbol, uint __decimals, uint __totalSupply, address __owner) internal {
        _name = __name;
        _symbol = __symbol;
        _decimals = __decimals;
        _decimalsMultiplier = 10 ** _decimals;
        uint256 generateTokens = __totalSupply * _decimalsMultiplier;
        _mint(__owner, generateTokens);
        approve(__owner, balanceOf(__owner));
        _transferOwnership(__owner);
    }

    function() external payable {
        revert();
    }
}
