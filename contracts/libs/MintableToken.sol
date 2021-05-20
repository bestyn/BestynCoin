pragma solidity ^0.5.0;

import "../ERC/ERC20.sol";

/**
 * @title Mintable token
 * @dev Simple ERC20 Token example, with mintable token creation
 * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
 */
contract MintableToken is ERC20 {

    event Mint(address indexed to, uint256 amount);

    event MintFinished();

    event MintStarted();

    bool public mintingFinished = false;

    modifier canMint() {
        require(!mintingFinished, "MintableToken: minting is finished");
        _;
    }

    modifier hasMintPermission() {
        require(msg.sender == owner, "MintableToken: sender has not permissions");
        _;
    }

    /**
     * @dev Function to mint tokens
     * @param _to The address that will receive the minted tokens.
     * @param _amount The amount of tokens to mint.
     * @return A boolean this indicates if the operation was successful.
     */
    function mint(address _to, uint256 _amount) public hasMintPermission canMint returns (bool) {
        _mint(_to, _amount);
        emit Mint(_to, _amount);
        return true;
    }

    /**
     * @dev Function to stop minting new tokens.
     * @return True if the operation was successful.
     */
    function finishMinting() public canMint returns (bool) {
        mintingFinished = true;
        emit MintFinished();
        return true;
    }

    function startMinting() public returns (bool) {
        mintingFinished = false;
        emit MintStarted();
        return true;
    }
}
