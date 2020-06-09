pragma solidity ^0.5.0;

import "./MainContract.sol";

contract Esillium is MainContract {
    function initialize() initializer public {
        MainContract.initialize('Esillium', '8YB', 5, 700000000, 0x158ad714bc7BEeaD490960eCB382717FA36Ef926);
      }
}
