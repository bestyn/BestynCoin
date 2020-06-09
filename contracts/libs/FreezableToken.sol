pragma solidity ^0.5.16;

import "./MintableToken.sol";

/**
 * @title Freezable token
 * @dev Add ability froze accounts
 */
contract FreezableToken is MintableToken {

    mapping(address => bool) public frozenAccounts;

    event FrozenFunds(address target, bool frozen);

    /**
     * @dev Freze account
     */
    function freezeAccount(address target, bool freeze) public onlyOwner {
        frozenAccounts[target] = freeze;
        emit FrozenFunds(target, freeze);
    }

    /**
     * @dev Ovveride base method _transfer from base ERC20 contract
     */
    function _transfer(address _from, address _to, uint256 value) internal {
        require(_to != address(0x0), "FreezableToken: transfer to the zero address");
        require(_balances[_from] >= value, "FreezableToken: balance _from must br bigger than value");
        require(_balances[_to] + value >= _balances[_to], "FreezableToken: balance to must br bigger than current balance");
        require(!frozenAccounts[_from], "FreezableToken: account _from is frozen");
        require(!frozenAccounts[_to], "FreezableToken: account _to is frozen");
        _balances[_from] = _balances[_from].sub(value);
        _balances[_to] = _balances[_to].add(value);
        emit Transfer(_from, _to, value);
    }
}