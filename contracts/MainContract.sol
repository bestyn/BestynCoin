pragma solidity ^0.5.0;

import "@openzeppelin/upgrades/contracts/Initializable.sol";
import "./libs/FreezableToken.sol";
import "./libs/Pausable.sol";

/**
 * @title MainContract
 * @dev Base contract which using for initializing new contract
 */
contract MainContract is FreezableToken, Pausable, Initializable {

    string private _name;

    string private _symbol;

    uint private _decimals;

    uint private _decimalsMultiplier;

    function initialize (string memory name, string memory symbol, uint decimals, uint totalSupply, address owner) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
        _decimalsMultiplier = 10 ** _decimals;
        if (paused) {
            pause();
        }
        mint(owner, totalSupply * _decimalsMultiplier);
        _approve(owner, owner, balanceOf(owner));
        transferOwnership(owner);
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

    function() external payable {revert();}
}
