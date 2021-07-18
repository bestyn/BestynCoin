pragma solidity ^0.5.0;

import "@openzeppelin/upgrades/contracts/Initializable.sol";
import "./MainContract.sol";

contract BaniContract is MainContract, Initializable {

     constructor () public {initialize();}

     function initialize() public initializer {
          owner = 0x6CEE4f0558c668C063BB8221deaA5bc25468f8a0;
          init('BANI', 'BANI', 5, 7000000000, owner);
     }
}
