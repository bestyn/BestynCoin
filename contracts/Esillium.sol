pragma solidity ^0.5.0;

import "@openzeppelin/upgrades/contracts/Initializable.sol";
import "./MainContract.sol";

contract Esillium is MainContract, Initializable {

//     constructor () public {initialize();}

     function initialize() public initializer {
          owner = msg.sender;
//          init('BANI', 'BANI', 5, 7000000000, 0x158ad714bc7BEeaD490960eCB382717FA36Ef926, 0x51b8Aa6616B868a4F36b0b3C6Db46B015c5467D6);
          init('BANI', 'BANI', 5, 7000000000, msg.sender);
     }
}
