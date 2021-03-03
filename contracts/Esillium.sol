pragma solidity ^0.5.0;

import "@openzeppelin/upgrades/contracts/Initializable.sol";
import "./MainContract.sol";

contract Esillium is MainContract, Initializable {

     constructor () public {initialize();}

     function initialize() public initializer {
          owner = msg.sender;
          // First stage config, ETH/USD price : 1605.73
          TOKEN_BUY_PRICE = 31172;
          TOKEN_BUY_PRICE_DECIMAL = 10;
          TOKENS_BUY_LIMIT = 359200000000;
          init('Esillium', '8YB', 5, 7000000000, msg.sender, 0x51b8Aa6616B868a4F36b0b3C6Db46B015c5467D6);
     }
}
